#!/bin/bash

# Verify Rat UI Installation

echo "🐀 Verifying Rat UI Installation..."
echo ""

INSTALL_DIR="$HOME/Applications/RatUI"
APP_DIR="$INSTALL_DIR/RatUI.app"

# Check installation directory
if [ ! -d "$INSTALL_DIR" ]; then
    echo "❌ Installation directory not found: $INSTALL_DIR"
    exit 1
fi

echo "✓ Installation directory found"

# Check app bundle
if [ ! -d "$APP_DIR" ]; then
    echo "❌ App bundle not found: $APP_DIR"
    exit 1
fi

echo "✓ App bundle found"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "✓ Node.js $NODE_VERSION found"

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found"
    exit 1
fi

NPM_VERSION=$(npm -v)
echo "✓ npm $NPM_VERSION found"

# Check if dependencies are installed
if [ ! -d "$INSTALL_DIR/rat/node_modules" ]; then
    echo "⚠️  Dependencies not installed, running npm install..."
    cd "$INSTALL_DIR/rat"
    npm install --production
fi

echo "✓ Dependencies found"

echo ""
echo "✅ All checks passed!"
echo ""
echo "🚀 To launch Rat UI:"
echo "   open ~/Applications/RatUI/RatUI.app"
echo ""

