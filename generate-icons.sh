#!/bin/bash

# Generate macOS Icon Set (.icns) from SVG
# Requires ImageMagick and iconutil

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SVG_FILE="$SCRIPT_DIR/assets/rat-icon.svg"
ASSETS_DIR="$SCRIPT_DIR/assets"
ICONSET_DIR="$ASSETS_DIR/rat-icon.iconset"
ICNS_FILE="$ASSETS_DIR/rat-icon.icns"

if [ ! -f "$SVG_FILE" ]; then
    echo "❌ SVG file not found: $SVG_FILE"
    exit 1
fi

echo "🐀 Generating macOS icon set..."

# Create iconset directory
mkdir -p "$ICONSET_DIR"

# Generate different sizes
SIZES=(16 32 64 128 256 512)

for SIZE in "${SIZES[@]}"; do
    OUTPUT="$ICONSET_DIR/icon_${SIZE}x${SIZE}.png"
    RETINA="$ICONSET_DIR/icon_${SIZE}x${SIZE}@2x.png"
    
    # Generate standard resolution
    convert -background none -size "${SIZE}x${SIZE}" "$SVG_FILE" "$OUTPUT"
    
    # Generate retina (2x)
    convert -background none -size "$((SIZE*2))x$((SIZE*2))" "$SVG_FILE" "$RETINA"
    
    echo "✓ Generated ${SIZE}x${SIZE}"
done

# Create .icns file
iconutil -c icns "$ICONSET_DIR" -o "$ICNS_FILE"

if [ -f "$ICNS_FILE" ]; then
    echo "✅ Icon set created: $ICNS_FILE"
    # Cleanup
    rm -rf "$ICONSET_DIR"
    echo "✓ Cleaned up temporary files"
else
    echo "❌ Failed to create icon set"
    exit 1
fi
