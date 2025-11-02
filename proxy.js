import express from "express";
import fetch from "node-fetch";
import path from "path";
import { fileURLToPath } from "url";

const app = express();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Servir ficheiros locais (index.html, ajuste.css, etc.)
app.use(express.static(__dirname));

// Proxy para buscar a página externa e injetar o CSS
app.get("/proxy", async (req, res) => {
    const targetUrl = req.query.url;
    if (!targetUrl) return res.status(400).send("Falta o parâmetro ?url=");

    try {
        const response = await fetch(targetUrl);
        let html = await response.text();

        // Injetar o CSS local no <head>
        html = html.replace(
            /<head[^>]*>/i,
            `<head><link rel="stylesheet" href="/ajuste.css">`
        );

        res.set("Content-Type", "text/html");
        res.send(html);
    } catch (err) {
        console.error("Erro ao buscar página:", err);
        res.status(500).send("Erro ao buscar a página externa.");
    }
});

// Iniciar servidor
const PORT = 3000;
app.listen(PORT, () =>
    console.log(`Servidor ativo em http://localhost:${PORT}`)
);
