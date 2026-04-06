#!/bin/bash

# This script recolors icons. It checks every SVG file in path and changes it's color.

usage() {
  echo "Usage: $0 <directory_path> \"<color_hex>\""
  echo "Example: $0 ./icons \"#FF0000\""
  echo "Color must be in #RRGGBB format."
  exit 1
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

if [ "$#" -ne 2 ]; then
    usage
fi

TARGET_DIR="$1"
NEW_COLOR="$2"

# Check for # followed by 6 characters (0-9, a-f, A-F)
if [[ ! "$NEW_COLOR" =~ ^#[0-9a-fA-F]{6}$ ]]; then
    echo "Error: Invalid color format '$NEW_COLOR'."
    echo "Color must be in #RRGGBB format (e.g., #FF4500)."
    exit 1
fi

# Check if directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found."
    exit 1
fi

echo "Recoloring SVGs in $TARGET_DIR to $NEW_COLOR..."

# Process all SVG files
for svg_file in "$TARGET_DIR"/*.svg; do
    [ -e "$svg_file" ] || continue

    echo "Processing: $(basename "$svg_file")"

    # Update fill color
    sed -i "s|fill=\"[^\"]*\"|fill=\"$NEW_COLOR\"|g" "$svg_file"

    # Add color if it didn't exist
    # Check if 'fill=' exists after the substitution to avoid double-insertion
    if ! grep -q "fill=" "$svg_file"; then
        sed -i "s|<path|<path fill=\"$NEW_COLOR\"|g" "$svg_file"
    fi
done

echo "Done."
