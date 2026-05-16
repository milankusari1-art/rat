# 🐀 Rat UI Installer - macOS Intel

Professional one-line installer for Rat UI on macOS Intel systems.

## Quick Start

```bash
curl -fsSL "https://your-domain.com/install.sh" | bash
```

*Replace the URL with your actual hosting location*

## What's Included

### 🔧 Installation Scripts

| Script | Purpose |
|--------|---------|
| `install.sh` | Main installer - handles everything |
| `build-installer.sh` | Builds distribution package |
| `generate-icons.sh` | Creates macOS icon set |
| `test-installer.sh` | Test installer in isolated environment |

### 📄 Documentation

| File | Purpose |
|------|---------|
| `INSTALL_MAC.md` | Complete installation guide |
| `DEPLOYMENT.md` | How to host and deploy the installer |
| `README.md` | Main project documentation |

### 🎨 Assets

| File | Purpose |
|------|---------|
| `assets/rat-icon.svg` | Green rat icon (scalable) |
| `assets/rat-icon.icns` | macOS app icon (generated) |

## Installer Features

✅ **System Compatibility Check**
- Verifies macOS Intel (x86_64) architecture
- Prevents installation on Apple Silicon Macs

✅ **Dependency Management**
- Checks for Git installation
- Verifies Node.js (installs via Homebrew if needed)
- Auto-installs npm packages

✅ **Application Setup**
- Creates macOS app bundle (.app)
- Generates proper Info.plist
- Sets up executable wrapper

✅ **User Integration**
- Creates Finder aliases
- Sets up command-line shortcuts
- Adds to system PATH
- Creates launch scripts

✅ **Error Handling**
- Graceful error messages
- Validation at each step
- Recovery suggestions

## Installation Steps

The installer performs these steps automatically:

1. **System Check**
   - Verify macOS Intel
   - Check command-line tools

2. **Dependencies**
   - Verify Git
   - Check/Install Node.js
   - Verify npm

3. **Repository**
   - Clone/Update from GitHub
   - Set up Git repository

4. **Compilation**
   - Install npm packages
   - Build app bundle

5. **Integration**
   - Create application shortcuts
   - Set up command aliases
   - Register with system

## Building the Installer

### Prerequisites
- macOS 10.13+
- Xcode Command Line Tools
- ImageMagick (for icon generation)
- Node.js 14+

### Build Steps

```bash
# 1. Generate icon assets
chmod +x generate-icons.sh
./generate-icons.sh

# 2. Build installer package
chmod +x build-installer.sh
./build-installer.sh

# 3. Test locally
chmod +x test-installer.sh
./test-installer.sh
```

The built files will be in the `dist/` directory.

## Deploying the Installer

### Option 1: GitHub Pages (Recommended)

```bash
# The workflow in .github/workflows/build-mac-installer.yml handles this automatically
# It deploys to GitHub Pages on each push to main

# Users install with:
curl -fsSL "https://username.github.io/rat/install.sh" | bash
```

### Option 2: Self-Hosted Server

```bash
# Copy to your server
scp install.sh user@your-domain.com:/var/www/rat-ui/

# Configure web server to serve as text/plain
# Users install with:
curl -fsSL "https://your-domain.com/install.sh" | bash
```

### Option 3: AWS S3 + CloudFront

```bash
# Upload to S3
aws s3 cp install.sh s3://rat-ui-installers/mac/install.sh --acl public-read

# Create CloudFront distribution
# Users install with:
curl -fsSL "https://d1234abcd.cloudfront.net/mac/install.sh" | bash
```

### Option 4: Docker

```bash
# Build Docker image
docker build -f Dockerfile.installer -t rat-ui-installer .

# Run locally for testing
docker run -p 8000:80 rat-ui-installer

# Users can test with:
curl -fsSL "http://localhost:8000/install.sh" | bash
```

See `DEPLOYMENT.md` for detailed deployment instructions.

## Testing

### Local Testing

```bash
# Test in isolated environment
./test-installer.sh
```

### Manual Testing

```bash
# Start local web server
cd /workspaces/rat
python3 -m http.server 8000

# In another terminal, test installation
curl -fsSL "http://localhost:8000/install.sh" | bash
```

### Automated Testing

GitHub Actions workflow automatically:
- Builds installer on each push
- Runs lint checks
- Verifies dependencies
- Creates artifacts

## Customization

### Modifying the Installer

Edit `install.sh`:
- Change `APP_NAME` variable
- Adjust `INSTALL_DIR` path
- Modify port settings
- Add/remove installation steps

### Custom Colors

Edit `public/styles.css`:
```css
:root {
    --primary-green: #00cc00;
    --dark-green: #004d00;
    --light-green: #99ff99;
    /* ... */
}
```

### Icon Customization

Replace `assets/rat-icon.svg` with your own SVG, then run:
```bash
./generate-icons.sh
```

## Troubleshooting

### Installation Fails on Apple Silicon

The installer explicitly checks for Intel architecture:
```bash
ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" ]]; then
    # Error: Apple Silicon not supported
fi
```

**Solution**: Use native Apple Silicon build or Rosetta 2 translation.

### Node.js Installation Fails

If Homebrew is not installed:
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Then install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Reinstall Node
brew install node
```

### Permission Denied Errors

Make sure scripts are executable:
```bash
chmod +x install.sh build-installer.sh generate-icons.sh
```

### App Won't Launch

Check App Store security settings:
```bash
# Bypass quarantine attribute
xattr -rd com.apple.quarantine ~/Applications/RatUI/RatUI.app
```

## Distribution

### Creating Distribution Bundle

```bash
# Build complete distribution
./build-installer.sh

# Contents of dist/ folder:
# - install.sh          (main installer)
# - README.md           (user guide)
# - verify-install.sh   (verification script)
# - uninstall.sh        (uninstall script)
```

### Publishing

1. **GitHub Releases**
   - Tag version: `git tag v1.0.0`
   - Push tag: `git push origin v1.0.0`
   - GitHub Actions creates release automatically

2. **Website**
   - Host on your website
   - Add download link
   - Provide checksum verification

3. **CDN**
   - Upload to CDN service
   - Enable gzip compression
   - Set cache headers

## Security

### Best Practices

✅ Use HTTPS only
✅ Sign installers with GPG
✅ Provide SHA256 checksums
✅ Keep installer updated
✅ Monitor for security issues

### Checksum Verification

```bash
# Generate checksum
sha256sum install.sh > install.sh.sha256

# Verify
sha256sum -c install.sh.sha256
```

### Signing with GPG

```bash
# Sign
gpg --sign install.sh

# Verify
gpg --verify install.sh.gpg
```

## Uninstallation

### Automatic

```bash
bash ~/Applications/RatUI/uninstall.sh
```

### Manual

```bash
# Remove application
rm -rf ~/Applications/RatUI

# Remove Finder alias
rm ~/Applications/Rat\ UI.app

# Remove from PATH
# Edit ~/.zprofile or ~/.bash_profile and remove rat-ui line
```

## System Integration

### Launch on Startup

Add to `~/.zprofile` or `~/.bash_profile`:
```bash
# Start Rat UI in background on login
open ~/Applications/RatUI/RatUI.app &
```

### Service Integration

Create LaunchAgent for auto-start:
```bash
mkdir -p ~/Library/LaunchAgents
cat > ~/Library/LaunchAgents/com.ratui.app.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ratui.app</string>
    <key>Program</key>
    <string>/Users/$(whoami)/Applications/RatUI/RatUI.app/Contents/MacOS/Rat UI</string>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Load service
launchctl load ~/Library/LaunchAgents/com.ratui.app.plist
```

## Contributing

To improve the installer:

1. Test changes locally with `./test-installer.sh`
2. Submit pull request
3. Describe changes in detail
4. Update documentation

## License

MIT License - See LICENSE file

---

## Support

- 📖 [Full Installation Guide](INSTALL_MAC.md)
- 🚀 [Deployment Guide](DEPLOYMENT.md)
- 💬 [GitHub Issues](https://github.com/milankusari1-art/rat/issues)
- 🐀 [Main Repository](https://github.com/milankusari1-art/rat)

---

**Version:** 1.0.0  
**Last Updated:** May 2024  
**Compatibility:** macOS 10.13+ (Intel only)
