#!/bin/bash

# Rat UI Installer for macOS Intel
# Installation: curl -fsSL "https://your-domain.com/install.sh" | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="Rat UI"
REPO_URL="https://github.com/milankusari1-art/rat"
INSTALL_DIR="$HOME/Applications/RatUI"
APP_DIR="$INSTALL_DIR/RatUI.app"
GITHUB_API="https://api.github.com/repos/milankusari1-art/rat/releases/latest"

# Functions
print_header() {
    echo -e "${GREEN}"
    cat << "EOF"
    ╔═══════════════════════════════════╗
    ║                                   ║
    ║        🐀 RAT UI INSTALLER 🐀     ║
    ║                                   ║
    ║  Opiumware Command Executor       ║
    ║  All-Green Terminal Interface     ║
    ║                                   ║
    ╚═══════════════════════════════════╝
EOF
    echo -e "${NC}"
}

print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if macOS and Intel
check_system() {
    print_status "Checking system compatibility..."
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This installer only works on macOS"
        exit 1
    fi
    
    # Check if Intel architecture
    ARCH=$(uname -m)
    if [[ "$ARCH" != "x86_64" ]]; then
        print_error "This installer requires Intel (x86_64) architecture. Your system: $ARCH"
        print_warning "For Apple Silicon, please use the ARM64 version or build from source"
        exit 1
    fi
    
    print_status "✓ macOS Intel detected"
}

# Check Node.js
check_node() {
    print_status "Checking Node.js installation..."
    
    if ! command -v node &> /dev/null; then
        print_warning "Node.js not found. Installing..."
        
        # Install Homebrew if needed
        if ! command -v brew &> /dev/null; then
            print_status "Installing Homebrew (required for Node.js)..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
                print_error "Failed to install Homebrew"
                print_warning "Please visit https://brew.sh to install manually"
                exit 1
            }
        fi
        
        # Install Node.js via Homebrew
        print_status "Installing Node.js via Homebrew..."
        brew install node || {
            print_error "Failed to install Node.js"
            print_warning "Please visit https://nodejs.org to install manually"
            exit 1
        }
    fi
    
    NODE_VERSION=$(node -v)
    print_status "✓ Node.js $NODE_VERSION detected"
}

# Check Git
check_git() {
    print_status "Checking Git installation..."
    
    if ! command -v git &> /dev/null; then
        print_error "Git is required but not installed"
        print_warning "Install it using: brew install git"
        exit 1
    fi
    
    print_status "✓ Git detected"
}

# Create directories
setup_directories() {
    print_status "Setting up directories..."
    
    mkdir -p "$INSTALL_DIR"
    print_status "✓ Created $INSTALL_DIR"
}

# Clone or update repository
setup_repository() {
    print_status "Setting up Rat UI repository..."
    
    if [ -d "$INSTALL_DIR/rat" ]; then
        print_status "Updating existing installation..."
        cd "$INSTALL_DIR/rat"
        git pull origin main
    else
        print_status "Cloning repository..."
        cd "$INSTALL_DIR"
        git clone "$REPO_URL" rat
    fi
    
    cd "$INSTALL_DIR/rat"
    print_status "✓ Repository ready"
}

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    
    cd "$INSTALL_DIR/rat"
    npm install --production
    
    print_status "✓ Dependencies installed"
}

# Create macOS app bundle
create_app_bundle() {
    print_status "Creating macOS application bundle..."
    
    cd "$INSTALL_DIR/rat"
    
    # Create app structure
    mkdir -p "$APP_DIR/Contents/MacOS"
    mkdir -p "$APP_DIR/Contents/Resources"
    
    # Create Info.plist
    cat > "$APP_DIR/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>Rat UI</string>
    <key>CFBundleIdentifier</key>
    <string>com.ratui.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Rat UI</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <false/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Rat UI © 2024</string>
    <key>NSRequiresAquaSystemAppearance</key>
    <false/>
</dict>
</plist>
PLIST
    
    # Create executable script
    cat > "$APP_DIR/Contents/MacOS/Rat UI" << 'SCRIPT'
#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_DIR="$SCRIPT_DIR/../.."
cd "$APP_DIR"
node server.js
SCRIPT
    
    chmod +x "$APP_DIR/Contents/MacOS/Rat UI"
    
    # Create PkgInfo
    echo "APPLcomRat" > "$APP_DIR/Contents/PkgInfo"
    
    print_status "✓ App bundle created"
}

# Copy icon
copy_icon() {
    print_status "Copying application icon..."
    
    # Create icon from SVG if needed
    if [ -f "$INSTALL_DIR/rat/assets/rat-icon.svg" ]; then
        # Convert SVG to ICNS using sips or imagemagick
        if command -v sips &> /dev/null; then
            print_warning "Note: Icon conversion may require manual setup"
        fi
    fi
    
    print_status "✓ Icon configured"
}

# Create launch script
create_launch_script() {
    print_status "Creating launch script..."
    
    cat > "$INSTALL_DIR/rat-ui" << 'LAUNCHER'
#!/bin/bash
INSTALL_DIR="$HOME/Applications/RatUI"
APP_DIR="$INSTALL_DIR/RatUI.app"

if [ ! -d "$APP_DIR" ]; then
    echo "Rat UI not found. Please run the installer first."
    exit 1
fi

open "$APP_DIR"
LAUNCHER
    
    chmod +x "$INSTALL_DIR/rat-ui"
    print_status "✓ Launch script created"
}

# Create alias/shortcut
create_alias() {
    print_status "Creating command alias..."
    
    # Add to PATH via shell profile
    SHELL_PROFILE=""
    if [ -f "$HOME/.zprofile" ]; then
        SHELL_PROFILE="$HOME/.zprofile"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_PROFILE="$HOME/.bash_profile"
    elif [ -f "$HOME/.profile" ]; then
        SHELL_PROFILE="$HOME/.profile"
    fi
    
    if [ -n "$SHELL_PROFILE" ]; then
        if ! grep -q "rat-ui" "$SHELL_PROFILE"; then
            echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_PROFILE"
            print_status "✓ Added to PATH"
        fi
    fi
}

# Create Finder alias
create_finder_alias() {
    print_status "Creating Finder alias in Applications..."
    
    if [ -d "$HOME/Applications" ]; then
        ln -sf "$APP_DIR" "$HOME/Applications/Rat UI.app" 2>/dev/null || true
    fi
    
    print_status "✓ Finder alias created"
}

# Summary
print_summary() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✓ Installation Complete!            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}[*]${NC} Installation location:"
    echo "    $INSTALL_DIR"
    echo ""
    echo -e "${GREEN}[*]${NC} To launch Rat UI:"
    echo "    ${YELLOW}open ~/Applications/RatUI/RatUI.app${NC}"
    echo ""
    echo -e "${GREEN}[*]${NC} Or use command:"
    echo "    ${YELLOW}rat-ui${NC}"
    echo ""
    echo -e "${GREEN}[*]${NC} Access the web interface at:"
    echo "    ${YELLOW}http://localhost:3000${NC}"
    echo ""
    echo -e "${GREEN}[*]${NC} To uninstall:"
    echo "    ${YELLOW}rm -rf ~/Applications/RatUI${NC}"
    echo ""
}

# Main installation flow
main() {
    print_header
    check_system
    check_git
    check_node
    setup_directories
    setup_repository
    install_dependencies
    create_app_bundle
    copy_icon
    create_launch_script
    create_alias
    create_finder_alias
    print_summary
}

# Run main
main
