#!/bin/bash
# ============================================================================
# Auto-export all STLs from OpenSCAD (no GUI needed)
# Run from the open-cad/ directory: bash export_all_stls.sh
#
# Source .scad files: cad/
# Output .stl files:  stl/
#
# Only the files listed below are processed — not all .scad files.
# ============================================================================

OPENSCAD="/c/Program Files/OpenSCAD/openscad.com"
CAD_DIR="cad"
STL_DIR="stl/parts"

mkdir -p "$STL_DIR"

# Explicit file list: "source_scad:output_stl"
# Only these files get exported — nothing else in cad/ is touched.
FILES=(
    "stl_all_hardware:all_hardware"
    "stl_weave_frame_left:weave_frame_left"
    "stl_weave_frame_right:weave_frame_right"
    "stl_weave_x_left:weave_x_left"
    "stl_weave_x_right:weave_x_right"
    "stl_weave_y_left:weave_y_left"
    "stl_weave_y_right:weave_y_right"
    "stl_tray_left:tray_left"
    "stl_tray_right:tray_right"
    "stl_lid_left:lid_left"
    "stl_lid_right:lid_right"
    "stl_bottom_left:bottom_left"
    "stl_bottom_right:bottom_right"
    "stl_split_clamp:split_clamps"
)

echo "=========================================="
echo "  OpenSCAD Batch STL Export"
echo "  Source: $CAD_DIR/  →  Output: $STL_DIR/"
echo "=========================================="

total=${#FILES[@]}
count=0

for entry in "${FILES[@]}"; do
    scad="${entry%%:*}"
    stl="${entry##*:}"
    count=$((count + 1))
    echo ""
    echo "[$count/$total] $CAD_DIR/$scad.scad → $STL_DIR/$stl.stl"
    "$OPENSCAD" -o "$STL_DIR/$stl.stl" "$CAD_DIR/$scad.scad"
    if [ $? -eq 0 ]; then
        echo "  Done"
    else
        echo "  FAILED"
    fi
done

echo ""
echo "=========================================="
echo "  Export complete"
echo "=========================================="
ls -lh "$STL_DIR"/*.stl 2>/dev/null
