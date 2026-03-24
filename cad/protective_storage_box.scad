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
// SPLIT PARTS — 3-piece: 320mm middle + two 50mm snap-on end caps
// ============================================================================
// Fits Creality K2 Plus (350mm bed). No screws or hardware needed.
// End caps slide onto the middle section via dovetail sleeve joints
// with snap-fit detents for a sturdy, tool-free connection.

// Split geometry
end_cap_len  = 50;                        // each end cap length
mid_start    = end_cap_len;               // middle starts at X=50
mid_end      = length - end_cap_len;      // middle ends at X=370
mid_len      = mid_end - mid_start;       // 320mm middle

// Sleeve joint parameters
sleeve_len     = 20;       // how far the sleeve overlap extends
sleeve_wall    = wall / 2; // half wall thickness for each mating surface
sleeve_gap     = 0.15;     // print tolerance / clearance
detent_h       = 0.6;      // snap bump height
detent_w       = 8;        // snap bump width
detent_pos_z_b = [wall + 20, bottom_h - 20]; // detent Z positions (bottom)
detent_pos_z_l = [wall + 12, lid_h - 12];    // detent Z positions (lid)

// --- Sleeve joint: middle section has thinned outer walls at each end ---
// End caps have a matching inner sleeve that wraps around the thinned section
// When pushed together: outer surfaces are flush, detents click into place

// Detent bumps — small ridges that snap into matching grooves
module _detent_bumps(z_positions) {
    for (z = z_positions)
        for (y = [wall/4, width - wall/4])
            translate([-0.01, y - detent_w/2, z - detent_w/2])
                rotate([0, 90, 0])
                    cylinder(d = detent_h * 2, h = 0.01 + sleeve_len * 0.3, $fn = 16);
}

module _detent_grooves(z_positions) {
    for (z = z_positions)
        for (y = [wall/4, width - wall/4])
            translate([-0.5, y - detent_w/2, z - detent_w/2])
                rotate([0, 90, 0])
                    cylinder(d = detent_h * 2 + sleeve_gap * 2, h = sleeve_len * 0.3 + 1, $fn = 16);
}

// ---- BOX BOTTOM: 3 pieces ----

module box_bottom_middle() {
    difference() {
        intersection() {
            box_bottom();
            translate([mid_start, -1, -standoff_h - 1])
                cube([mid_len, width + 2, bottom_h + standoff_h + 2]);
        }
        // Thin the outer walls at both ends for sleeve joint
        // Left end: remove outer half of front/back walls
        for (y_start = [-0.01, width - sleeve_wall])
            translate([mid_start - 0.01, y_start, -0.01])
                cube([sleeve_len + 0.01, sleeve_wall + 0.01, bottom_h + 0.02]);
        // Right end: same
        for (y_start = [-0.01, width - sleeve_wall])
            translate([mid_end - sleeve_len, y_start, -0.01])
                cube([sleeve_len + 0.01, sleeve_wall + 0.01, bottom_h + 0.02]);
        // Detent grooves at both ends
        translate([mid_start, 0, 0]) _detent_grooves(detent_pos_z_b);
        translate([mid_end, 0, 0]) mirror([1,0,0]) _detent_grooves(detent_pos_z_b);
    }
    // Shift to origin for printing
    // (already near origin since mid_start=50, acceptable)
}

module box_bottom_end_left() {
    difference() {
        union() {
            // The end cap itself
            intersection() {
                box_bottom();
                translate([-1, -1, -standoff_h - 1])
                    cube([end_cap_len + 1, width + 2, bottom_h + standoff_h + 2]);
            }
            // Inner sleeve extensions — wrap around thinned middle walls
            for (y_start = [sleeve_gap, width - sleeve_wall + sleeve_gap]) {
                translate([end_cap_len, y_start, wall])
                    cube([sleeve_len - sleeve_gap, sleeve_wall - 2*sleeve_gap, bottom_h - wall]);
            }
        }
        // Floor clearance for sleeve (don't block the bottom)
        // Nothing needed — sleeve sits above the floor
    }
    // Detent bumps on the sleeve
    translate([end_cap_len, 0, 0]) _detent_bumps(detent_pos_z_b);
}

module box_bottom_end_right() {
    right_start = mid_end;
    translate([-right_start, 0, 0])
    difference() {
        union() {
            intersection() {
                box_bottom();
                translate([right_start, -1, -standoff_h - 1])
                    cube([end_cap_len + 1, width + 2, bottom_h + standoff_h + 2]);
            }
            // Inner sleeve extensions
            for (y_start = [sleeve_gap, width - sleeve_wall + sleeve_gap]) {
                translate([right_start - sleeve_len + sleeve_gap, y_start, wall])
                    cube([sleeve_len - sleeve_gap, sleeve_wall - 2*sleeve_gap, bottom_h - wall]);
            }
        }
    }
    // Detent bumps
    translate([-right_start, 0, 0])
    translate([right_start, 0, 0]) mirror([1,0,0]) _detent_bumps(detent_pos_z_b);
}

// ---- BOX LID: 3 pieces ----

module box_lid_middle() {
    difference() {
        intersection() {
            box_lid();
            translate([mid_start, -1, -1])
                cube([mid_len, width + 2, lid_h + 2]);
        }
        // Thin outer walls at both ends
        for (y_start = [-0.01, width - sleeve_wall])
            translate([mid_start - 0.01, y_start, -0.01])
                cube([sleeve_len + 0.01, sleeve_wall + 0.01, lid_h + 0.02]);
        for (y_start = [-0.01, width - sleeve_wall])
            translate([mid_end - sleeve_len, y_start, -0.01])
                cube([sleeve_len + 0.01, sleeve_wall + 0.01, lid_h + 0.02]);
        // Detent grooves
        translate([mid_start, 0, 0]) _detent_grooves(detent_pos_z_l);
        translate([mid_end, 0, 0]) mirror([1,0,0]) _detent_grooves(detent_pos_z_l);
    }
}

module box_lid_end_left() {
    difference() {
        union() {
            intersection() {
                box_lid();
                translate([-1, -1, -1])
                    cube([end_cap_len + 1, width + 2, lid_h + 2]);
            }
            for (y_start = [sleeve_gap, width - sleeve_wall + sleeve_gap]) {
                translate([end_cap_len, y_start, wall])
                    cube([sleeve_len - sleeve_gap, sleeve_wall - 2*sleeve_gap, lid_h - wall]);
            }
        }
    }
    translate([end_cap_len, 0, 0]) _detent_bumps(detent_pos_z_l);
}

module box_lid_end_right() {
    right_start = mid_end;
    translate([-right_start, 0, 0])
    difference() {
        union() {
            intersection() {
                box_lid();
                translate([right_start, -1, -1])
                    cube([end_cap_len + 1, width + 2, lid_h + 2]);
            }
            for (y_start = [sleeve_gap, width - sleeve_wall + sleeve_gap]) {
                translate([right_start - sleeve_len + sleeve_gap, y_start, wall])
                    cube([sleeve_len - sleeve_gap, sleeve_wall - 2*sleeve_gap, lid_h - wall]);
            }
        }
    }
    translate([-right_start, 0, 0])
    translate([right_start, 0, 0]) mirror([1,0,0]) _detent_bumps(detent_pos_z_l);
}

// ---- TRAY: 3 independent open boxes (compartments) ----
// The middle section is split into 3 equal compartments with divider walls.
// Each compartment is a standalone open box that sits in the main box.

tray_inner_l = length - 2 * wall - 2 * tray_gap;
tray_inner_w = width - 2 * wall - 2 * tray_gap;
tray_cap_len = end_cap_len - wall - tray_gap;
tray_mid_total = tray_inner_l - 2 * tray_cap_len;
n_compartments = 3;
compartment_gap = 1;  // gap between compartments
compartment_len = (tray_mid_total - (n_compartments - 1) * compartment_gap) / n_compartments;

module tray_compartment() {
    // Single open box compartment
    cw = tray_inner_w;
    difference() {
        rounded_box(compartment_len, cw, tray_h, max(inner_r, 2));
        translate([tray_wall, tray_wall, tray_wall])
            rounded_box(compartment_len - 2*tray_wall, cw - 2*tray_wall,
                        tray_h + 1, max(inner_r - tray_wall, 1));
    }
}

module tray_middle() {
    // 3 compartments side by side along X
    for (i = [0 : n_compartments - 1]) {
        translate([i * (compartment_len + compartment_gap), 0, 0])
            tray_compartment();
    }
}

module tray_end_left() {
    // Left end cap compartment
    cw = tray_inner_w;
    difference() {
        rounded_box(tray_cap_len, cw, tray_h, max(inner_r, 2));
        translate([tray_wall, tray_wall, tray_wall])
            rounded_box(tray_cap_len - 2*tray_wall, cw - 2*tray_wall,
                        tray_h + 1, max(inner_r - tray_wall, 1));
        // Finger notch on the short end
        translate([tray_cap_len/2 - notch_w/2, -0.01, tray_h - notch_h])
            cube([notch_w, tray_wall + 0.02, notch_h + 0.01]);
    }
}

module tray_end_right() {
    // Right end cap compartment
    cw = tray_inner_w;
    difference() {
        rounded_box(tray_cap_len, cw, tray_h, max(inner_r, 2));
        translate([tray_wall, tray_wall, tray_wall])
            rounded_box(tray_cap_len - 2*tray_wall, cw - 2*tray_wall,
                        tray_h + 1, max(inner_r - tray_wall, 1));
        // Finger notch on the short end
        translate([tray_cap_len/2 - notch_w/2, cw - tray_wall - 0.01, tray_h - notch_h])
            cube([notch_w, tray_wall + 0.02, notch_h + 0.01]);
    }
}

// ---- Combined print plates ----
// Plate 1: All box bottom parts — middle at origin, end caps beside it
module print_plate_box() {
    // Middle bottom shifted to origin (it normally starts at X=mid_start)
    translate([-mid_start, 0, 0])
        box_bottom_middle();
    // Left end cap beside middle (gap of 10mm)
    translate([mid_len + 10, 0, 0])
        box_bottom_end_left();
    // Right end cap beside left cap
    translate([mid_len + 10 + end_cap_len + 10, 0, 0])
        box_bottom_end_right();
}

// Plate 2: All lid parts — flipped for printing (opening up)
module print_plate_lid() {
    // Middle lid shifted to origin and flipped
    rotate([180, 0, 0]) translate([-mid_start, -width, -lid_h])
        box_lid_middle();
    // Left end cap
    translate([mid_len + 10, 0, 0])
        rotate([180, 0, 0]) translate([0, -width, -lid_h])
            box_lid_end_left();
    // Right end cap
    translate([mid_len + 10 + end_cap_len + 10, 0, 0])
        rotate([180, 0, 0]) translate([0, -width, -lid_h])
            box_lid_end_right();
}

// Plate 3: All tray compartments + hardware
module print_plate_small() {
    // 3 middle compartments
    tray_middle();
    // End cap trays beside them
    translate([tray_mid_total + 10, 0, 0])
        tray_end_left();
    translate([tray_mid_total + 10 + tray_cap_len + 10, 0, 0])
        tray_end_right();
    // Hardware below with gap
    translate([0, tray_inner_w + 15, 0]) {
        hinge_print_layout();
        translate([0, 30, 0]) hinge_print_layout();
        translate([0, 60, 0]) latch_print_layout();
        translate([0, 100, 0]) latch_print_layout();
    }
}

// ---- Legacy aliases for backward compat ----
module box_bottom_left() { box_bottom_end_left(); }
module box_bottom_right() { box_bottom_end_right(); }
module box_lid_left() { box_lid_end_left(); }
module box_lid_right() { box_lid_end_right(); }
module tray_left() { tray_end_left(); }
module tray_right() { tray_end_right(); }

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
