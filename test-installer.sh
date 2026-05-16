#!/bin/bash

# Local Test Script for Rat UI Installer
# Run this in a VM or container to safely test the installer

set -e

TEST_DIR="/tmp/rat-ui-test-$$"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🐀 Starting Rat UI Installer Test"
echo "Test directory: $TEST_DIR"
echo ""

# Create test environment
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Copy installer
cp "$SCRIPT_DIR/install.sh" ./
chmod +x ./install.sh

echo "📋 Test Environment:"
echo "  macOS Version: $(sw_vers -productVersion)"
echo "  Architecture: $(uname -m)"
echo "  Shell: $SHELL"
echo "  Home: $HOME"
echo ""

# Create mock home for testing
# export HOME="$TEST_DIR/mock-home"
# mkdir -p "$HOME"

echo "🚀 Running Installer..."
bash ./install.sh

echo ""
echo "✅ Installer Test Complete!"
echo ""

# Verify installation
if [ -d "$HOME/Applications/RatUI" ]; then
    echo "✓ Installation directory created"
    
    if [ -d "$HOME/Applications/RatUI/RatUI.app" ]; then
        echo "✓ App bundle created"
    else
        echo "❌ App bundle not found"
        exit 1
    fi
    
    if [ -d "$HOME/Applications/RatUI/rat" ]; then
        echo "✓ Repository cloned"
        
        if [ -f "$HOME/Applications/RatUI/rat/server.js" ]; then
            echo "✓ Server.js found"
        fi
        
        if [ -d "$HOME/Applications/RatUI/rat/node_modules" ]; then
            echo "✓ Dependencies installed"
        fi
    fi
else
    echo "❌ Installation directory not found"
    exit 1
fi

echo ""
echo "📊 Installation Summary:"
ls -lh "$HOME/Applications/RatUI/"
echo ""
echo "🧹 To cleanup test:"
echo "  rm -rf ~/Applications/RatUI"
echo "  rm -rf $TEST_DIR"
