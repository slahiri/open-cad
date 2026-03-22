include <../cad/protective_storage_box.scad>
lid_angle = 0;
show_tray_in_assembly = false;
rotate([180, 0, 0]) translate([0, -width, -lid_h]) box_lid_right();
