// ============================================================================
// CREALITY K2 PLUS — Multi-Color Export Guide
// ============================================================================
// Bed: 350×350×350mm  |  CFS: 4 filaments  |  Slicer: Creality Print / Orca
//
// WORKFLOW:
//   1. Uncomment ONE print plate section below
//   2. F6 (Render) → F7 (Export STL) for EACH color separately
//   3. Import all STLs for that plate into Creality Print as one project
//   4. Assign each STL to a filament slot (color)
//   5. Slice and print
//
// The box is 420mm — too long for 350mm bed.
// All box/lid/tray parts are SPLIT into left + right halves.
// Halves join with alignment pins + M4 bolts after printing.
//
// SUGGESTED 4 FILAMENT SLOTS:
//   Slot 1: Dark Gray PETG   (box body, lid, frame)
//   Slot 2: White PETG       (weave X-strips)
//   Slot 3: Blue PETG        (weave Y-strips, tray)
//   Slot 4: Black PETG       (latches, hinges)
// ============================================================================
include <../cad/protective_storage_box.scad>

// Override — don't render the default assembly
lid_angle = 0;
show_tray_in_assembly = false;
tray_lift = 0;

// ============================================================================
// PLATE 1: Box Bottom — Left Half
// Size: ~210×110×105mm  |  Color: Slot 1 (Dark Gray)
// Orientation: upright  |  Supports: NO  |  Infill: 40%  |  Walls: 4
// ============================================================================
//box_bottom_left();

// ============================================================================
// PLATE 2: Box Bottom — Right Half
// Size: ~210×110×105mm  |  Color: Slot 1 (Dark Gray)
// Orientation: upright  |  Supports: NO  |  Infill: 40%  |  Walls: 4
// ============================================================================
//box_bottom_right();

// ============================================================================
// PLATE 3: Box Lid — Left Half (FLIP in slicer: rotate 180° around X)
// Size: ~210×110×60mm  |  Color: Slot 1 (Dark Gray)
// Orientation: flip upside down  |  Supports: NO  |  Infill: 40%
// ============================================================================
//rotate([180, 0, 0]) translate([0, -width, -lid_h]) box_lid_left();

// ============================================================================
// PLATE 4: Box Lid — Right Half (FLIP in slicer: rotate 180° around X)
// Size: ~210×110×60mm  |  Color: Slot 1 (Dark Gray)
// Orientation: flip upside down  |  Supports: NO  |  Infill: 40%
// ============================================================================
//rotate([180, 0, 0]) translate([0, -width, -lid_h]) box_lid_right();

// ============================================================================
// PLATE 5: Tray — Left Half
// Size: ~206×102×40mm  |  Color: Slot 3 (Blue)
// Orientation: upright  |  Supports: NO  |  Infill: 20%  |  Walls: 3
// ============================================================================
//tray_left();

// ============================================================================
// PLATE 6: Tray — Right Half
// Size: ~206×102×40mm  |  Color: Slot 3 (Blue)
// Orientation: upright  |  Supports: NO  |  Infill: 20%  |  Walls: 3
// ============================================================================
//tray_right();

// ============================================================================
// PLATE 7: Weave Insert — MULTI-COLOR (3 STLs, same coordinates)
// ============================================================================
// Export EACH line below as a SEPARATE STL file, then import ALL THREE
// into Creality Print as one project. They will auto-align.
//
// Step 1: Uncomment lid_weave_frame(), render (F6), export as "weave_frame.stl"
// Step 2: Uncomment lid_weave_x_strips(), render, export as "weave_x_white.stl"
// Step 3: Uncomment lid_weave_y_strips(), render, export as "weave_y_blue.stl"
// Then in Creality Print: import all 3 → assign colors → slice
//
// Supports: NO  |  Infill: 100%  |  Layer: 0.15mm  |  Walls: 3
//
//lid_weave_frame();       // → Slot 1 (Dark Gray)
//lid_weave_x_strips();    // → Slot 2 (White)
//lid_weave_y_strips();    // → Slot 3 (Blue)

// ============================================================================
// PLATE 8: Hardware — Hinges × 2 + Latches × 2 (all Slot 4: Black)
// ============================================================================
// These are small enough to fit on one plate together.
// Supports: YES (auto)  |  Infill: 60%  |  Walls: 4  |  Layer: 0.15mm
//
// Hinge set 1
//hinge_print_layout();
// Hinge set 2
//translate([0, 30, 0]) hinge_print_layout();
// Latch set 1
//translate([0, 60, 0]) latch_print_layout();
// Latch set 2
//translate([0, 100, 0]) latch_print_layout();

// ============================================================================
// ALL HARDWARE ON ONE PLATE (uncomment this whole block)
// ============================================================================
/*
hinge_print_layout();
translate([0, 30, 0]) hinge_print_layout();
translate([0, 60, 0]) latch_print_layout();
translate([0, 100, 0]) latch_print_layout();
*/

// ============================================================================
// PRINT ORDER (recommended):
// ============================================================================
// 1. Plate 8  — Hardware (small, quick, test your settings)
// 2. Plate 7  — Weave insert (multi-color test)
// 3. Plates 5+6 — Tray halves (medium)
// 4. Plates 3+4 — Lid halves (large)
// 5. Plates 1+2 — Bottom halves (largest, longest print)
//
// ASSEMBLY AFTER PRINTING:
// 1. Join box bottom halves: insert alignment pins, secure with M4×25mm bolts
// 2. Join lid halves: same method
// 3. Join tray halves: glue with PETG-safe adhesive (or friction fit)
// 4. Press-fit weave strips into frame, insert into lid recess
// 5. Attach hinges to back wall with M3×10mm screws
// 6. Insert M3×25mm rod through hinge barrels
// 7. Attach latch bases to bottom front, levers to lid front
// 8. Glue rubber pads into standoff recesses
// 9. Press 1mm silicone cord into gasket groove
//
// HARDWARE SHOPPING LIST:
// - 4× M4×25mm bolts + nuts (joining box halves)
// - 4× M4×25mm bolts + nuts (joining lid halves)
// - 12× M3×10mm screws (hinges + latches)
// - 2× M3×25mm smooth rod or bolt (hinge pins)
// - 6× rubber bumper pads 10mm (standoff feet)
// - ~1m silicone cord 1mm diameter (gasket)
// - PETG adhesive / epoxy (tray halves)
// ============================================================================
