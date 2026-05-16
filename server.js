const express = require("express");
const path = require("path");
const Net = require("net");
const Zlib = require("zlib");

const app = express();
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

async function execute(Code, Port) {
    const Ports = ["8392", "8393", "8394", "8395", "8396", "8397"];
    let ConnectedPort = null,
        Stream = null;

    for (const P of (Port === "ALL" ? Ports : [Port])) {
        try {
            Stream = await new Promise((Resolve, Reject) => {
                const Socket = Net.createConnection({
                    host: "127.0.0.1",
                    port: parseInt(P)
                }, () => Resolve(Socket));
                Socket.on("error", Reject);
            });
            console.log(`Successfully connected to Opiumware on port: ${P}`);
            ConnectedPort = P;
            break;
        } catch (Err) {
            console.log(`Failed to connect to port ${P}: ${Err.message}`);
        }
    }

    if (!Stream) return { success: false, message: "Failed to connect on all ports" };

    if (Code !== "NULL") {
        try {
            await new Promise((Resolve, Reject) => {
                Zlib.deflate(Buffer.from(Code, "utf8"), (Err, Compressed) => {
                    if (Err) return Reject(Err);
                    Stream.write(Compressed, (WriteErr) => {
                        if (WriteErr) return Reject(WriteErr);
                        console.log(`Script sent (${Compressed.length} bytes)`);
                        Resolve();
                    });
                });
            });
        } catch (Err) {
            Stream.destroy();
            return { success: false, message: `Error sending script: ${Err.message}` };
        }
    }

    Stream.end();
    return { success: true, message: `Successfully connected to Opiumware on port: ${ConnectedPort}`, port: ConnectedPort };
}

app.post("/api/execute", async (req, res) => {
    const { code, port } = req.body;
    
    if (!code || !port) {
        return res.status(400).json({ success: false, message: "Code and port are required" });
    }

    try {
        const result = await execute(code, port);
        res.json(result);
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Rat UI Server running on http://localhost:${PORT}`);
});
