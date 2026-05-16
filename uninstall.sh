#!/bin/bash

# Rat UI Uninstaller

echo "🐀 Uninstalling Rat UI..."

INSTALL_DIR="$HOME/Applications/RatUI"
SHELL_PROFILE=""

# Determine shell profile
if [ -f "$HOME/.zprofile" ]; then
    SHELL_PROFILE="$HOME/.zprofile"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_PROFILE="$HOME/.bash_profile"
elif [ -f "$HOME/.profile" ]; then
    SHELL_PROFILE="$HOME/.profile"
fi

# Remove from PATH
if [ -n "$SHELL_PROFILE" ] && grep -q "rat-ui" "$SHELL_PROFILE"; then
    sed -i.bak '/rat-ui/d' "$SHELL_PROFILE"
    echo "✓ Removed from PATH"
fi

# Remove Finder alias
if [ -L "$HOME/Applications/Rat UI.app" ]; then
    rm "$HOME/Applications/Rat UI.app"
    echo "✓ Removed Finder alias"
fi

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo "✓ Removed installation directory"
fi

echo "✅ Uninstall complete"

