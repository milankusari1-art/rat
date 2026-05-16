# macOS Installation Guide - Rat UI

## One-Line Installation (Recommended)

```bash
curl -fsSL "https://usecelestial.xyz/rat-install.sh" | bash
```

Replace `https://usecelestial.xyz/rat-install.sh` with your actual hosting URL.

## What the Installer Does

✅ Checks system compatibility (macOS Intel only)
✅ Verifies Git and Node.js are installed
✅ Clones the Rat UI repository
✅ Installs npm dependencies
✅ Creates a macOS application bundle
✅ Sets up launch commands and aliases
✅ Creates Finder shortcuts

## Manual Installation

If you prefer to install manually or encounter issues:

### 1. Clone the Repository
```bash
git clone https://github.com/milankusari1-art/rat
cd rat
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Start the Application
```bash
npm start
```

The app will start on `http://localhost:3000`

## Launching After Installation

### Using Finder
1. Open Finder
2. Go to Applications
3. Double-click "Rat UI.app"

### Using Terminal
```bash
rat-ui
```

### Using Open Command
```bash
open ~/Applications/RatUI/RatUI.app
```

### Using Full Path
```bash
open ~/Applications/RatUI/RatUI.app/Contents/MacOS/"Rat UI"
```

## Accessing the Web Interface

Once running, open your browser and navigate to:
```
http://localhost:3000
```

## Customizing Port

To use a different port (default is 3000):

```bash
PORT=8080 npm start
```

## Stopping the Application

In the terminal where it's running, press:
```
Ctrl + C
```

## Uninstallation

### Automatic Uninstall
```bash
bash ~/Applications/RatUI/uninstall.sh
```

### Manual Uninstall
```bash
# Remove the application
rm -rf ~/Applications/RatUI

# Remove Finder alias
rm ~/Applications/Rat\ UI.app

# Remove from PATH (if added to shell profile)
# Edit ~/.zprofile, ~/.bash_profile, or ~/.profile and remove the rat-ui PATH line
```

## System Requirements

- **OS**: macOS (Intel processor)
- **Architecture**: x86_64
- **Node.js**: v14.0.0 or higher
- **RAM**: 512 MB minimum
- **Disk Space**: 500 MB

## Troubleshooting

### "Rat UI" is damaged and can't be opened

This is a macOS security warning. To bypass:

1. Right-click on the app
2. Select "Open"
3. Click "Open" in the confirmation dialog
4. The app should now open normally

Alternative:
```bash
xattr -rd com.apple.quarantine ~/Applications/RatUI/RatUI.app
```

### Port 3000 Already in Use

If port 3000 is in use by another application:

```bash
# Find what's using port 3000
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use a different port
PORT=8080 npm start
```

### Node.js Not Found

Install Node.js:

**Option 1: Homebrew (Recommended)**
```bash
brew install node
```

**Option 2: Direct Download**
Visit https://nodejs.org and download the macOS installer

**Option 3: NVM**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
```

### Git Not Found

Install Git:

**Option 1: Homebrew**
```bash
brew install git
```

**Option 2: Xcode Command Line Tools**
```bash
xcode-select --install
```

### npm install Fails

Try clearing npm cache:
```bash
npm cache clean --force
npm install
```

If that doesn't work, remove node_modules and reinstall:
```bash
rm -rf node_modules
rm package-lock.json
npm install
```

### Connection Refused

Make sure you're running the app:
```bash
npm start
```

And accessing it at:
```
http://localhost:3000
```

(Not https://)

## Environment Variables

```bash
# Change port
PORT=8080 npm start

# Development mode
NODE_ENV=development npm start

# Opiumware connection timeout (ms)
OPIUM_TIMEOUT=5000 npm start
```

## Getting Help

- Check the [GitHub Issues](https://github.com/milankusari1-art/rat/issues)
- Review server logs in the terminal
- Verify all system requirements are met

## Updating

To update to the latest version:

```bash
cd ~/Applications/RatUI/rat
git pull origin main
npm install
```

Then restart the application.

---

Enjoy your green-themed Rat UI! 🐀💚
