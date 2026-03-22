// ============================================================================
// EXPORT HELPER — Single-color, generic printer
// ============================================================================
// For Creality K2 Plus multi-color, use export_k2plus.scad instead!
//
// Uncomment ONE part at a time, then:
//   F6 (Render) → F7 (Export STL)
// ============================================================================
include <../cad/protective_storage_box.scad>

lid_angle = 0;
show_tray_in_assembly = false;
tray_lift = 0;

// ---- FULL PARTS (need 420mm+ bed) ----
//box_bottom();
//rotate([180, 0, 0]) translate([0, -width, -lid_h]) box_lid();
//tray();
//lid_mesh_insert();

// ---- SPLIT PARTS (fits 350mm bed) ----
//box_bottom_left();
//box_bottom_right();
//rotate([180, 0, 0]) translate([0, -width, -lid_h]) box_lid_left();
//rotate([180, 0, 0]) translate([0, -width, -lid_h]) box_lid_right();
//tray_left();
//tray_right();

// ---- WEAVE (3 separate STLs for multi-color) ----
//lid_weave_frame();
//lid_weave_x_strips();
//lid_weave_y_strips();

// ---- HARDWARE ----
//hinge_print_layout();    // Print 2×
//latch_print_layout();    // Print 2×

// ---- ALL HARDWARE ON ONE PLATE ----
/*
hinge_print_layout();
translate([0, 30, 0]) hinge_print_layout();
translate([0, 60, 0]) latch_print_layout();
translate([0, 100, 0]) latch_print_layout();
*/
