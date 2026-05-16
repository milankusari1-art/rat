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

