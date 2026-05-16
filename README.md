# 🐀 Rat UI - Green Terminal Interface

A sleek, all-green themed web UI for executing Opiumware scripts with an integrated Node.js backend.

## Features

✨ **All-Green Theme** - Matrix-style green terminal aesthetic
🎨 **Modern UI** - Clean, intuitive interface with real-time feedback
⚡ **Script Execution** - Send compressed scripts to Opiumware instances
🔌 **Multi-Port Support** - Connect to ports 8392-8397 or all ports at once
📊 **Live Results** - Real-time execution results with timestamp logging
🎯 **Responsive Design** - Works on desktop and mobile devices

## Installation

1. Install dependencies:
```bash
npm install
```

2. Start the server:
```bash
npm start
```

3. Open in your browser:
```
http://localhost:3000
```

## Usage

1. **Select Target Port**: Choose which port(s) to connect to
   - **ALL** - Tries all ports (8392-8397) sequentially
   - **Individual Port** - Connect to a specific port

2. **Enter Script Code**: Type or paste your Opiumware script
   ```
   Example: print('hello world')
   ```

3. **Execute**: Click the "Execute" button

4. **View Results**: Check the results panel for execution status and messages

## API Endpoints

### POST /api/execute
Executes a script on the Opiumware server

**Request Body:**
```json
{
  "code": "print('your script here')",
  "port": "ALL" or "8392-8397"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Successfully connected to Opiumware on port: 8392",
  "port": "8392"
}
```

## Architecture

- **Frontend**: HTML5 + CSS3 + Vanilla JavaScript
- **Backend**: Node.js + Express.js
- **Protocol**: TCP Socket + Zlib Compression
- **Styling**: Custom CSS with green terminal theme

## Project Structure

```
rat/
├── public/
│   ├── index.html       # Main UI page
│   ├── styles.css       # Green theme styling
│   └── script.js        # Frontend logic
├── server.js            # Express server & API
├── package.json         # Dependencies
└── README.md           # This file
```

## Configuration

The application connects to Opiumware instances on:
- Port 8392
- Port 8393
- Port 8394
- Port 8395
- Port 8396
- Port 8397

These ports can be modified in `server.js` if needed.

## Development

To modify the green theme, edit the CSS variables in `styles.css`:

```css
:root {
    --primary-green: #00cc00;
    --dark-green: #004d00;
    --light-green: #99ff99;
    /* ... */
}
```

## Browser Support

- Chrome/Chromium (Latest)
- Firefox (Latest)
- Safari (Latest)
- Edge (Latest)

## License

MIT
