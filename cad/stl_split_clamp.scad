include <protective_storage_box.scad>
lid_angle = 0;
show_tray_in_assembly = false;
render_assembly = false;
// Print 4-6 clamps: 2 per joint (front + back wall), for bottom and lid
split_clamp();
translate([0, 20, 0]) split_clamp();
translate([0, 40, 0]) split_clamp();
translate([0, 60, 0]) split_clamp();
translate([0, 80, 0]) split_clamp();
translate([0, 100, 0]) split_clamp();
