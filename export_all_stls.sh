#!/bin/bash
# ============================================================================
# Auto-export all STLs from OpenSCAD (no GUI needed)
# Run from the open-cad/ directory: bash export_all_stls.sh
#
# Source .scad files: cad/
# Output .stl files:  stl/parts/
#
# Only the files listed below are processed — not all .scad files.
# ============================================================================

OPENSCAD="/c/Program Files/OpenSCAD/openscad.com"
CAD_DIR="cad"
STL_DIR="stl/parts"

mkdir -p "$STL_DIR"

# 3 print plates:
#   1. plate_box   — main box (bottom middle + 2 end caps)
#   2. plate_lid   — lid (middle + 2 end caps)
#   3. plate_small — tray compartments (3 middle + 2 ends) + hardware
FILES=(
    "stl_plate_box:plate_box"
    "stl_plate_lid:plate_lid"
    "stl_plate_small:plate_small"
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
