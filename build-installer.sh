#!/bin/bash

# Rat UI Build & Deploy Script
# Prepares the installer for distribution

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$PROJECT_DIR/dist"
VERSION="1.0.0"

echo "🐀 Building Rat UI Distribution Package..."

# Create dist directory
mkdir -p "$DIST_DIR"

# Copy install script
cp "$PROJECT_DIR/install.sh" "$DIST_DIR/install.sh"
chmod +x "$DIST_DIR/install.sh"

# Create README for distribution
cat > "$DIST_DIR/README.md" << 'EOF'
# 🐀 Rat UI - macOS Installer

One-line installation for Rat UI on macOS Intel.

## Installation

```bash
curl -fsSL "https://your-domain.com/install.sh" | bash
```

### Requirements
- macOS with Intel processor
- Git installed
- Node.js (will be installed if missing)

### Manual Installation

```bash
git clone https://github.com/milankusari1-art/rat
cd rat
npm install
npm start
```

## Launching

After installation, launch with:
```bash
open ~/Applications/RatUI/RatUI.app
```

Or from terminal:
```bash
rat-ui
```

## Accessing

Open your browser to: `http://localhost:3000`

## Uninstall

```bash
rm -rf ~/Applications/RatUI
```

## Troubleshooting

### "Rat UI" is damaged and can't be opened
Right-click and select "Open" to bypass security warnings on first run.

### Node.js not found
Install Node.js from https://nodejs.org or use Homebrew:
```bash
brew install node
```

### Port already in use
The app uses port 3000 by default. To use a different port:
```bash
PORT=8080 open ~/Applications/RatUI/RatUI.app
```

EOF

# Create verification script
cat > "$DIST_DIR/verify-install.sh" << 'EOF'
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

EOF

chmod +x "$DIST_DIR/verify-install.sh"

# Create uninstall script
cat > "$DIST_DIR/uninstall.sh" << 'EOF'
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

EOF

chmod +x "$DIST_DIR/uninstall.sh"

echo "✅ Distribution package created in: $DIST_DIR"
echo ""
echo "Files:"
ls -lh "$DIST_DIR"
echo ""
echo "To deploy: Upload install.sh to your web server"
echo "Installation command:"
echo "curl -fsSL \"https://your-domain.com/install.sh\" | bash"
