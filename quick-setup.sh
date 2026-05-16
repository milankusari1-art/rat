#!/bin/bash

# Quick Setup Script for Rat UI Installer Hosting
# This script helps you quickly set up and test the installer

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$PROJECT_DIR/install.sh"

echo "🐀 Rat UI Installer - Quick Setup"
echo "=================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️  This setup is for macOS. Building on other systems may have different requirements."
fi

# Option menu
echo "What would you like to do?"
echo ""
echo "1) Build installer distribution package"
echo "2) Test installer locally"
echo "3) Start local web server for testing"
echo "4) Generate macOS icons"
echo "5) View installation guide"
echo "6) View deployment guide"
echo ""

read -p "Enter choice (1-6): " choice

case $choice in
    1)
        echo ""
        echo "Building installer distribution..."
        chmod +x "$PROJECT_DIR/build-installer.sh"
        "$PROJECT_DIR/build-installer.sh"
        echo ""
        echo "✅ Distribution ready in: $PROJECT_DIR/dist/"
        ;;
    2)
        echo ""
        echo "Testing installer in isolated environment..."
        chmod +x "$PROJECT_DIR/test-installer.sh"
        "$PROJECT_DIR/test-installer.sh"
        ;;
    3)
        echo ""
        echo "Starting local web server..."
        cd "$PROJECT_DIR"
        echo "🌐 Server running at: http://localhost:8000"
        echo ""
        echo "Installation command:"
        echo "  curl -fsSL 'http://localhost:8000/install.sh' | bash"
        echo ""
        echo "Press Ctrl+C to stop server"
        python3 -m http.server 8000
        ;;
    4)
        echo ""
        echo "Generating macOS icons..."
        chmod +x "$PROJECT_DIR/generate-icons.sh"
        "$PROJECT_DIR/generate-icons.sh"
        echo ""
        echo "✅ Icons generated: $PROJECT_DIR/assets/rat-icon.icns"
        ;;
    5)
        echo ""
        less "$PROJECT_DIR/INSTALL_MAC.md"
        ;;
    6)
        echo ""
        less "$PROJECT_DIR/DEPLOYMENT.md"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Done! 🎉"
