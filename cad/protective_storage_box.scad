// ============================================================================
// Protective Storage Box — Pelican/Gun Case Style
// Material: PETG recommended  |  Units: mm
// ============================================================================
//
// Modules:
//   box_bottom()         — Bottom half (100mm, with standoff feet)
//   box_lid()            — Top lid (60mm, 3D rounded top edge)
//   tray()               — Removable interior tray (40mm)
//   lid_weave_frame()    — Weave border frame
//   lid_weave_x_strips() — Weave lengthwise strips (White)
//   lid_weave_y_strips() — Weave widthwise strips (Blue)
//   hinge_part_a/b()     — Barrel hinge halves (print 2× each)
//   latch_base_part()    — Large gun-box latch hook (print 2×)
//   latch_lever_part()   — Large butterfly lever (print 2×)
//   standoff_foot()      — Bottom standoff/rubber foot
//
// Use view files for different configurations, or change variables below.
// ============================================================================

// --- View Controls ---
// Change these to switch views (or use the separate view_*.scad files)
lid_angle = 120;               // 0=closed, 90=upright, 120=fully open
show_tray_in_assembly = true;  // show/hide tray
tray_lift = 0;                 // 0=inside box, >0=lifted out by this many mm
render_assembly = true;        // set false in export files to suppress assembly

// --- Global Parameters ---
length       = 420;
width        = 110;
total_height = 160;
corner_r     = 10;    // corner radius (vertical edges + bottom fillet)
wall         = 4;

// Split heights
bottom_h = 100;
lid_h    = 60;

// Interior
inner_r = 4;

// Tray
tray_h      = 40;
tray_gap    = 0.4;
tray_wall   = 2;
ledge_h     = 1;
ledge_depth = 1.5;

// Gasket groove
gasket_w = 1;
gasket_d = 1;

// Finger notch on tray
notch_w = 50;
notch_h = 20;

// Hinge parameters
hinge_barrel_d  = 8;
hinge_barrel_l  = 20;
hinge_leaf_l    = 20;
hinge_leaf_t    = 2.5;
hinge_pin_d     = 3;
hinge_screw_d   = 3;
hinge_tolerance = 0.3;

// Latch parameters — LARGE gun-box style
latch_w         = 36;    // wide clamp
latch_plate_h   = 24;    // tall mounting plate
latch_plate_t   = 3;     // thick plate
latch_hook_h    = 10;    // tall hook post
latch_hook_t    = 3;     // thick hook
latch_lever_h   = 30;    // long lever arm
latch_lever_t   = 2.5;   // lever thickness
latch_wing_h    = 16;    // large butterfly wings
latch_wing_d    = 14;    // deep wing protrusion

// Weave insert
mesh_margin    = 12;
mesh_depth     = 3;
mesh_strip_w   = 4;
mesh_strip_gap = 3;
mesh_border    = 3;
mesh_gap       = 0.2;

// Standoff feet
standoff_d     = 14;    // foot diameter
standoff_h     = 5;     // foot height
standoff_inset = 25;    // inset from box corners

// Split parameters (for printers with <420mm bed, e.g. K2 Plus 350mm)
split_x        = length / 2;  // split at center
split_pin_d    = 6;           // alignment pin diameter
split_pin_h    = 8;           // alignment pin length (half on each side)
split_bolt_d   = 4;           // M4 bolt hole diameter
split_gap      = 0.15;        // clearance for pin holes

// Placement
hinge_spacing = length / 3;
latch_spacing = length / 3;

// Resolution
$fn = 40;

// ============================================================================
// HELPERS
// ============================================================================

// Flat rounded box (cylindrical corners — flat top & bottom)
module rounded_box(l, w, h, r) {
    hull() {
        for (x = [r, l - r])
            for (y = [r, w - r])
                translate([x, y, 0])
                    cylinder(r = r, h = h);
    }
}

// 3D rounded box — filleted bottom edge, flat top, rounded vertical corners
// Used for outer shells to give a smooth, premium gun-case feel
module rounded_box_fillet(l, w, h, r) {
    hull() {
        for (x = [r, l - r])
            for (y = [r, w - r]) {
                // Bottom: sphere gives a smooth curved fillet
                translate([x, y, r])
                    sphere(r = r, $fn = 24);
                // Top: thin cylinder keeps the top edge flat (for mating)
                translate([x, y, h - 0.01])
                    cylinder(r = r, h = 0.01);
            }
    }
}

// ============================================================================
// MODULE: standoff_foot — Rubber foot pad for bottom of case
// ============================================================================
module standoff_foot() {
    difference() {
        union() {
            // Tapered foot
            cylinder(d1 = standoff_d + 2, d2 = standoff_d, h = standoff_h, $fn = 30);
            // Flared base blending into box
            cylinder(d1 = standoff_d + 6, d2 = standoff_d + 2, h = 2, $fn = 30);
        }
        // Rubber pad recess (glue in a rubber bumper)
        translate([0, 0, -0.01])
            cylinder(d = standoff_d - 4, h = 1.5, $fn = 30);
    }
}

// ============================================================================
// MODULE: box_bottom — with filleted edges and standoff feet
// ============================================================================
module box_bottom() {
    inner_l = length - 2 * wall;
    inner_w = width  - 2 * wall;
    inner_h = bottom_h - wall;

    difference() {
        // Outer shell — filleted bottom edge, flat top for lid mating
        rounded_box_fillet(length, width, bottom_h, corner_r);

        // Interior cavity
        translate([wall, wall, wall])
            rounded_box(inner_l, inner_w, inner_h + 1, inner_r);

        // Gasket groove around top mating edge
        translate([0, 0, bottom_h - gasket_d])
            difference() {
                rounded_box(length, width, gasket_d + 0.01, corner_r);
                translate([wall + gasket_w, wall + gasket_w, -0.01])
                    rounded_box(
                        inner_l - 2 * gasket_w,
                        inner_w - 2 * gasket_w,
                        gasket_d + 0.03,
                        max(inner_r - gasket_w, 1)
                    );
            }

        // Hinge screw holes on back wall
        for (i = [1, 2]) {
            hx = i * hinge_spacing;
            for (zoff = [bottom_h - hinge_leaf_l * 0.33,
                         bottom_h - hinge_leaf_l * 0.67]) {
                translate([hx, width - wall - 0.01, zoff])
                    rotate([-90, 0, 0])
                        cylinder(d = hinge_screw_d, h = wall + 0.02);
            }
        }

        // Latch screw holes on front wall
        for (i = [1, 2]) {
            lx = i * latch_spacing;
            for (zoff = [bottom_h - latch_plate_h * 0.33,
                         bottom_h - latch_plate_h * 0.67]) {
                translate([lx, -0.01, zoff])
                    rotate([-90, 0, 0])
                        cylinder(d = hinge_screw_d, h = wall + 0.02);
            }
        }
    }

    // Interior ledge for tray support
    ledge_z = bottom_h - tray_h;
    translate([wall, wall, ledge_z - ledge_h])
        difference() {
            rounded_box(inner_l, inner_w, ledge_h, inner_r);
            translate([ledge_depth, ledge_depth, -0.01])
                rounded_box(
                    inner_l - 2 * ledge_depth,
                    inner_w - 2 * ledge_depth,
                    ledge_h + 0.02,
                    max(inner_r - ledge_depth, 1)
                );
        }

    // Standoff feet on the underside
    standoff_positions = [
        [standoff_inset, standoff_inset],
        [standoff_inset, width - standoff_inset],
        [length / 2, standoff_inset],
        [length / 2, width - standoff_inset],
        [length - standoff_inset, standoff_inset],
        [length - standoff_inset, width - standoff_inset]
    ];
    for (pos = standoff_positions)
        translate([pos[0], pos[1], 0])
            mirror([0, 0, 1])
                standoff_foot();
}

// ============================================================================
// MODULE: box_lid — filleted top edge (visible top when assembled)
// ============================================================================
module box_lid() {
    inner_l = length - 2 * wall;
    inner_w = width  - 2 * wall;
    inner_h = lid_h - wall;

    difference() {
        // Outer shell — filleted bottom edge (becomes visible TOP after flip)
        // Flat top edge (becomes MATING surface after flip)
        rounded_box_fillet(length, width, lid_h, corner_r);

        // Interior cavity — open at top (Z=lid_h), solid ceiling at bottom
        // After mirror in assembly: solid face = visible top, open = mating side
        translate([wall, wall, wall])
            rounded_box(inner_l, inner_w, inner_h + 0.01, inner_r);

        // Hinge screw holes on back wall
        for (i = [1, 2]) {
            hx = i * hinge_spacing;
            for (zoff = [lid_h - (lid_h - wall) * 0.33,
                         lid_h - (lid_h - wall) * 0.67]) {
                translate([hx, width - wall - 0.01, zoff])
                    rotate([-90, 0, 0])
                        cylinder(d = hinge_screw_d, h = wall + 0.02);
            }
        }

        // Latch screw holes on front wall
        for (i = [1, 2]) {
            lx = i * latch_spacing;
            translate([lx, -0.01, lid_h * 0.5])
                rotate([-90, 0, 0])
                    cylinder(d = hinge_screw_d, h = wall + 0.02);
        }

        // Recess for weave insert on outer surface (Z=0 in lid coords)
        translate([mesh_margin, mesh_margin, -0.01])
            rounded_box(
                length - 2 * mesh_margin,
                width - 2 * mesh_margin,
                mesh_depth + 0.01,
                max(corner_r - mesh_margin, 2)
            );
    }
}

// ============================================================================
// MODULE: tray — Removable interior tray with finger notches
// ============================================================================
module tray() {
    inner_l = length - 2 * wall;
    inner_w = width  - 2 * wall;
    tray_l  = inner_l - 2 * tray_gap;
    tray_w  = inner_w - 2 * tray_gap;

    difference() {
        rounded_box(tray_l, tray_w, tray_h, inner_r);

        translate([tray_wall, tray_wall, tray_wall])
            rounded_box(
                tray_l - 2 * tray_wall,
                tray_w - 2 * tray_wall,
                tray_h + 1,
                max(inner_r - tray_wall, 1)
            );

        // Finger cutouts on BOTH short sides
        for (y_pos = [-0.01, tray_w - tray_wall - 0.01]) {
            translate([tray_l / 2 - notch_w / 2, y_pos, tray_h - notch_h])
                cube([notch_w, tray_wall + 0.02, notch_h + 0.01]);
            translate([tray_l / 2, y_pos, tray_h - notch_h])
                rotate([-90, 0, 0])
                    scale([notch_w / (2 * 5), 1, 1])
                        cylinder(r = 5, h = tray_wall + 0.02, $fn = 40);
        }
    }
}

// ============================================================================
// WEAVE INSERT — Basket-weave in two colors (White + Blue)
// ============================================================================
function weave_insert_l() = length - 2 * mesh_margin - 2 * mesh_gap;
function weave_insert_w() = width  - 2 * mesh_margin - 2 * mesh_gap;
function weave_insert_r() = max(corner_r - mesh_margin, 2);

module lid_weave_frame() {
    il = weave_insert_l();
    iw = weave_insert_w();
    ir = weave_insert_r();
    difference() {
        rounded_box(il, iw, mesh_depth, ir);
        translate([mesh_border, mesh_border, -0.01])
            rounded_box(il - 2*mesh_border, iw - 2*mesh_border,
                        mesh_depth + 0.02, max(ir - mesh_border, 1));
    }
}

module lid_weave_x_strips() {
    il = weave_insert_l();  iw = weave_insert_w();  ir = weave_insert_r();
    pitch = mesh_strip_w + mesh_strip_gap;  half_h = mesh_depth / 2;
    intersection() {
        translate([mesh_border, mesh_border, 0])
            rounded_box(il - 2*mesh_border, iw - 2*mesh_border,
                        mesh_depth, max(ir - mesh_border, 1));
        union() {
            for (iy = [0 : floor((iw - 2*mesh_border) / pitch)])
                for (ix = [0 : floor((il - 2*mesh_border) / pitch)]) {
                    x = mesh_border + ix * pitch;
                    y = mesh_border + iy * pitch;
                    z = ((ix + iy) % 2 == 0) ? half_h : 0;
                    translate([x, y, z]) cube([pitch, mesh_strip_w, half_h]);
                }
        }
    }
}

module lid_weave_y_strips() {
    il = weave_insert_l();  iw = weave_insert_w();  ir = weave_insert_r();
    pitch = mesh_strip_w + mesh_strip_gap;  half_h = mesh_depth / 2;
    intersection() {
        translate([mesh_border, mesh_border, 0])
            rounded_box(il - 2*mesh_border, iw - 2*mesh_border,
                        mesh_depth, max(ir - mesh_border, 1));
        union() {
            for (ix = [0 : floor((il - 2*mesh_border) / pitch)])
                for (iy = [0 : floor((iw - 2*mesh_border) / pitch)]) {
                    x = mesh_border + ix * pitch;
                    y = mesh_border + iy * pitch;
                    z = ((ix + iy) % 2 == 0) ? 0 : half_h;
                    translate([x, y, z]) cube([mesh_strip_w, pitch, half_h]);
                }
        }
    }
}

module lid_mesh_insert() {
    lid_weave_frame();
    lid_weave_x_strips();
    lid_weave_y_strips();
}

// --- Split weave parts (for beds <420mm) ---
// Weave split at center; each half ~198mm, fits on 350mm bed.
weave_split_x = weave_insert_l() / 2;

module lid_weave_frame_left() {
    il = weave_insert_l();
    intersection() {
        lid_weave_frame();
        translate([-1, -1, -0.01])
            cube([weave_split_x + 1, il + 2, mesh_depth + 0.02]);
    }
}

module lid_weave_frame_right() {
    il = weave_insert_l();
    translate([-weave_split_x, 0, 0])
    intersection() {
        lid_weave_frame();
        translate([weave_split_x, -1, -0.01])
            cube([il - weave_split_x + 1, il + 2, mesh_depth + 0.02]);
    }
}

module lid_weave_x_strips_left() {
    il = weave_insert_l();
    intersection() {
        lid_weave_x_strips();
        translate([-1, -1, -0.01])
            cube([weave_split_x + 1, il + 2, mesh_depth + 0.02]);
    }
}

module lid_weave_x_strips_right() {
    il = weave_insert_l();
    translate([-weave_split_x, 0, 0])
    intersection() {
        lid_weave_x_strips();
        translate([weave_split_x, -1, -0.01])
            cube([il - weave_split_x + 1, il + 2, mesh_depth + 0.02]);
    }
}

module lid_weave_y_strips_left() {
    il = weave_insert_l();
    intersection() {
        lid_weave_y_strips();
        translate([-1, -1, -0.01])
            cube([weave_split_x + 1, il + 2, mesh_depth + 0.02]);
    }
}

module lid_weave_y_strips_right() {
    il = weave_insert_l();
    translate([-weave_split_x, 0, 0])
    intersection() {
        lid_weave_y_strips();
        translate([weave_split_x, -1, -0.01])
            cube([il - weave_split_x + 1, il + 2, mesh_depth + 0.02]);
    }
}

// ============================================================================
// HINGE PARTS
// ============================================================================
module hinge_part_a() {
    knuckle_l = (hinge_barrel_l - 2 * hinge_tolerance) / 3;
    br = hinge_barrel_d / 2;
    difference() {
        union() {
            translate([0, 0, -hinge_leaf_l])
                cube([hinge_barrel_l, hinge_leaf_t, hinge_leaf_l + br]);
            for (xo = [0, 2 * (knuckle_l + hinge_tolerance)])
                translate([xo, hinge_leaf_t, 0])
                    rotate([0, 90, 0]) cylinder(r = br, h = knuckle_l);
        }
        translate([-0.1, hinge_leaf_t, 0])
            rotate([0, 90, 0]) cylinder(d = hinge_pin_d + 0.3, h = hinge_barrel_l + 0.2);
        for (zoff = [-hinge_leaf_l * 0.33, -hinge_leaf_l * 0.67])
            translate([hinge_barrel_l / 2, -0.01, zoff])
                rotate([-90, 0, 0]) cylinder(d = hinge_screw_d, h = hinge_leaf_t + 0.02);
    }
}

module hinge_part_b() {
    knuckle_l = (hinge_barrel_l - 2 * hinge_tolerance) / 3;
    br = hinge_barrel_d / 2;
    difference() {
        union() {
            translate([0, 0, -br])
                cube([hinge_barrel_l, hinge_leaf_t, hinge_leaf_l + br]);
            translate([knuckle_l + hinge_tolerance, hinge_leaf_t, 0])
                rotate([0, 90, 0]) cylinder(r = br, h = knuckle_l);
        }
        translate([-0.1, hinge_leaf_t, 0])
            rotate([0, 90, 0]) cylinder(d = hinge_pin_d + 0.3, h = hinge_barrel_l + 0.2);
        for (zoff = [hinge_leaf_l * 0.33, hinge_leaf_l * 0.67])
            translate([hinge_barrel_l / 2, -0.01, zoff])
                rotate([-90, 0, 0]) cylinder(d = hinge_screw_d, h = hinge_leaf_t + 0.02);
    }
}

module hinge_print_layout() {
    rotate([90, 0, 0]) hinge_part_a();
    translate([hinge_barrel_l + 5, 0, 0]) rotate([90, 0, 0]) hinge_part_b();
}

// ============================================================================
// LATCH PARTS — Large gun-box style butterfly clamps
// ============================================================================
module latch_base_part() {
    difference() {
        union() {
            // Wide mounting plate
            translate([-latch_w / 2, -latch_plate_t, 0])
                cube([latch_w, latch_plate_t, latch_plate_h]);

            // Thick hook post
            translate([-latch_hook_t / 2, -latch_plate_t, latch_plate_h])
                cube([latch_hook_t, latch_plate_t, latch_hook_h]);

            // Wide catch bar at top
            translate([-latch_w / 2 + 3, -latch_plate_t, latch_plate_h + latch_hook_h - 3])
                cube([latch_w - 6, latch_plate_t + 2, 3]);

            // Reinforcement gussets on sides of hook
            for (side = [-1, 1])
                translate([side * (latch_hook_t / 2 + 1) - 1, -latch_plate_t, latch_plate_h])
                    cube([2, latch_plate_t, latch_hook_h * 0.6]);
        }

        // Screw holes
        for (zoff = [latch_plate_h * 0.25, latch_plate_h * 0.75])
            translate([0, 0.01, zoff])
                rotate([90, 0, 0]) cylinder(d = hinge_screw_d, h = latch_plate_t + 0.02);
    }
}

module latch_lever_part() {
    difference() {
        union() {
            // Wide mounting plate
            translate([-latch_w / 2, -latch_lever_t, 0])
                cube([latch_w, latch_lever_t, latch_plate_h]);

            // Lever arm extending downward
            translate([-latch_hook_t / 2 - 1, -latch_lever_t, -latch_lever_h + latch_plate_h])
                cube([latch_hook_t + 2, latch_lever_t, latch_lever_h]);

            // Snap hook at bottom (catches under base bar)
            translate([-latch_w / 2 + 4, -latch_lever_t - 2, -latch_lever_h + latch_plate_h])
                cube([latch_w - 8, latch_lever_t + 2, 3.5]);

            // Large butterfly wings — ergonomic grip
            hull() {
                translate([-latch_w / 2, -latch_wing_d, latch_plate_h * 0.15])
                    cube([latch_w, latch_wing_d - latch_lever_t, latch_wing_h]);
                translate([-latch_w / 2 + 4, -latch_wing_d - 3, latch_plate_h * 0.15 + 3])
                    cube([latch_w - 8, 1, latch_wing_h - 6]);
            }
        }

        // Hollow out wings for flex and lighter weight
        translate([-latch_w / 2 + 4, -latch_wing_d + 2, latch_plate_h * 0.15 + 2])
            cube([latch_w - 8, latch_wing_d - latch_lever_t - 4, latch_wing_h - 4]);

        // Inner channel to grip over hook bar
        translate([-latch_w / 2 + 5, -latch_lever_t - 2.5,
                   -latch_lever_h + latch_plate_h + 3])
            cube([latch_w - 10, 3, 4]);

        // Screw hole
        translate([0, 0.01, latch_plate_h * 0.5])
            rotate([90, 0, 0]) cylinder(d = hinge_screw_d, h = latch_lever_t + 0.02);
    }
}

module latch_print_layout() {
    rotate([90, 0, 0]) latch_base_part();
    translate([latch_w + 10, 0, 0]) rotate([90, 0, 0]) latch_lever_part();
}

// ============================================================================
// SPLIT PARTS — For beds smaller than 420mm (e.g. Creality K2 Plus 350mm)
// ============================================================================
// Each half is ~210×110mm, fits easily on a 350mm bed.
// Halves join with interlocking lap joint + printable clamp clips.

// Lap joint parameters
lap_depth = wall / 2;        // half the wall thickness overlaps
lap_length = 10;             // overlap length along X axis

// Clamp parameters
clamp_thickness = 2.5;       // clamp wall thickness
clamp_clearance = 0.3;       // fit clearance
clamp_grip      = 15;        // how far clamp extends onto each half
clamp_tab_h     = 8;         // height of each clamp tab

// --- Lap joint cutout shapes ---
// Left half keeps outer wall at cut, inner is recessed
// Right half keeps inner wall at cut, outer is recessed
// When mated, they interlock like a step joint

module _lap_cut_outer(h) {
    // Cuts the outer half of the wall at the split face
    translate([split_x - lap_length, -0.01, -0.01])
        cube([lap_length + 0.01, wall/2 + 0.01, h + 0.02]);
    translate([split_x - lap_length, width - wall/2, -0.01])
        cube([lap_length + 0.01, wall/2 + 0.01, h + 0.02]);
}

module _lap_cut_inner(h) {
    // Cuts the inner half of the wall at the split face
    translate([split_x - lap_length, wall/2, -0.01])
        cube([lap_length + 0.01, wall/2 + 0.01, h + 0.02]);
    translate([split_x - lap_length, width - wall, -0.01])
        cube([lap_length + 0.01, wall/2 + 0.01, h + 0.02]);
}

// --- Split clamp clip — prints flat, snaps over the joint ---
module split_clamp() {
    // U-shaped clip that grips over the box wall at the joint
    inner_gap = wall + 2 * clamp_clearance;
    outer_w = inner_gap + 2 * clamp_thickness;
    total_l = 2 * clamp_grip;

    difference() {
        // Outer shell
        translate([-clamp_grip, -clamp_thickness, 0])
            cube([total_l, outer_w, clamp_tab_h]);
        // Inner channel (fits over wall)
        translate([-clamp_grip - 0.01, clamp_clearance, -0.01])
            cube([total_l + 0.02, inner_gap, clamp_tab_h + 0.02]);
        // Entry chamfer for easier snap-on
        translate([-clamp_grip - 0.01, -clamp_thickness - 0.01, clamp_tab_h - 1.5])
            rotate([0, 0, 0])
                cube([total_l + 0.02, clamp_thickness * 0.6, 1.51]);
        translate([-clamp_grip - 0.01, inner_gap + clamp_clearance, clamp_tab_h - 1.5])
            cube([total_l + 0.02, clamp_thickness * 0.6, 1.51]);
    }
    // Inner grip ridges for friction
    for (side = [0, inner_gap + clamp_clearance - 0.4])
        for (xo = [-clamp_grip + 3, clamp_grip - 4])
            translate([xo, side, 1])
                cube([1, 0.4, clamp_tab_h - 2]);
}

module box_bottom_left() {
    difference() {
        intersection() {
            box_bottom();
            translate([-1, -1, -standoff_h - 1])
                cube([split_x + lap_length + 1, width + 2, bottom_h + standoff_h + 2]);
        }
        // Remove inner wall at the overlap zone (right side mates here)
        _lap_cut_inner(bottom_h);
    }
}

module box_bottom_right() {
    translate([-split_x, 0, 0])
    difference() {
        intersection() {
            box_bottom();
            translate([split_x - lap_length, -1, -standoff_h - 1])
                cube([length - split_x + lap_length + 1, width + 2, bottom_h + standoff_h + 2]);
        }
        // Remove outer wall at the overlap zone (left side mates here)
        _lap_cut_outer(bottom_h);
    }
}

module box_lid_left() {
    difference() {
        intersection() {
            box_lid();
            translate([-1, -1, -1])
                cube([split_x + lap_length + 1, width + 2, lid_h + 2]);
        }
        _lap_cut_inner(lid_h);
    }
}

module box_lid_right() {
    translate([-split_x, 0, 0])
    difference() {
        intersection() {
            box_lid();
            translate([split_x - lap_length, -1, -1])
                cube([length - split_x + lap_length + 1, width + 2, lid_h + 2]);
        }
        _lap_cut_outer(lid_h);
    }
}

module tray_left() {
    inner_l = length - 2 * wall;
    tray_l = inner_l - 2 * tray_gap;
    intersection() {
        tray();
        translate([-1, -1, -1])
            cube([tray_l / 2 + lap_length + 1, width, tray_h + 2]);
    }
}

module tray_right() {
    inner_l = length - 2 * wall;
    tray_l = inner_l - 2 * tray_gap;
    translate([-tray_l / 2, 0, 0])
    intersection() {
        tray();
        translate([tray_l / 2 - lap_length, -1, -1])
            cube([tray_l / 2 + lap_length + 1, width, tray_h + 2]);
    }
}

// ============================================================================
// ASSEMBLY MODULE — call with different parameters for different views
// ============================================================================
module assembly(lid_ang = 120, show_tray = true, tray_z_lift = 0) {
    pivot_y = width;
    pivot_z = bottom_h;

    // ---- Bottom box (fixed) ----
    color("DimGray")
        box_bottom();

    // ---- Tray ----
    if (show_tray) {
        color("SteelBlue", 0.85)
            translate([wall + tray_gap, wall + tray_gap,
                       bottom_h - tray_h + tray_z_lift])
                tray();
    }

    // ---- Hinge Part A — fixed on bottom box ----
    for (i = [1, 2]) {
        hx = i * hinge_spacing - hinge_barrel_l / 2;
        color("Orange")
            translate([hx, pivot_y, pivot_z])
                hinge_part_a();
    }

    // ---- Latch base — fixed on bottom box ----
    for (i = [1, 2]) {
        lx = i * latch_spacing;
        color("Gold")
            translate([lx, 0, bottom_h - latch_plate_h - latch_hook_h])
                latch_base_part();
    }

    // ---- Everything below rotates with the lid ----
    translate([0, pivot_y, pivot_z])
    rotate([-lid_ang, 0, 0])
    translate([0, -pivot_y, -pivot_z])
    {
        // Lid
        color("SlateGray")
            translate([0, 0, total_height])
                mirror([0, 0, 1])
                    box_lid();

        // Weave insert — two colors
        translate([mesh_margin + mesh_gap, mesh_margin + mesh_gap,
                   total_height - mesh_depth])
        {
            color("DimGray")  lid_weave_frame();
            color("White")    lid_weave_x_strips();
            color("RoyalBlue") lid_weave_y_strips();
        }

        // Hinge Part B — rotates with lid
        for (i = [1, 2]) {
            hx = i * hinge_spacing - hinge_barrel_l / 2;
            color("OrangeRed")
                translate([hx, pivot_y, pivot_z])
                    hinge_part_b();
        }

        // Latch lever — rotates with lid
        for (i = [1, 2]) {
            lx = i * latch_spacing;
            color("Goldenrod")
                translate([lx, 0, bottom_h])
                    latch_lever_part();
        }
    }
}

// ============================================================================
// DEFAULT VIEW — uses the view control variables at the top of the file
// ============================================================================
if (render_assembly)
    assembly(lid_ang = lid_angle,
             show_tray = show_tray_in_assembly,
             tray_z_lift = tray_lift);

// ============================================================================
// INDIVIDUAL PART EXPORT
// ============================================================================
// Comment out the assembly() call above, then uncomment ONE line:
//
// box_bottom();
// box_lid();
// tray();
// lid_weave_frame();      // Print 1× (border frame)
// lid_weave_x_strips();   // Print 1× in White
// lid_weave_y_strips();   // Print 1× in Blue
// lid_mesh_insert();      // Print 1× combined (single color)
// hinge_print_layout();   // Print 2 sets
// latch_print_layout();   // Print 2 sets

// ============================================================================
// PRINT NOTES
// ============================================================================
// - Material: PETG for impact resistance
// - Box bottom: Print upright, no supports needed
// - Box lid: Print upside down (opening facing up), no supports
// - Tray: Print upright, no supports
// - Hinges: Use hinge_print_layout(), print flat, minimal supports
// - Latches: Use latch_print_layout(), print flat, minimal supports
// - Weave strips: Print flat in White/Blue, press-fit into lid recess
// - Layer height: 0.2mm  |  Infill: 30-50%  |  Walls: 3-4 perimeters
// - Use M3×25mm bolt or smooth rod as hinge pin
// - Glue rubber bumper pads into standoff recesses for grip
// - Gasket groove accepts 1mm diameter silicone cord/o-ring
// ============================================================================
