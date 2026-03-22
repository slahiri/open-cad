include <../cad/protective_storage_box.scad>
lid_angle = 0;
show_tray_in_assembly = false;
hinge_print_layout();
translate([0, 30, 0]) hinge_print_layout();
translate([0, 60, 0]) latch_print_layout();
translate([0, 100, 0]) latch_print_layout();
