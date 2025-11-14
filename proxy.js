const express = require("express");
const fetch = require("node-fetch"); // usa node-fetch v2
const path = require("path");
const { exec } = require("child_process");

const app = express();
const PORT = 3000;
const __dirname_actual = path.resolve();

// Abrir browser automaticamente
const openBrowser = () => {
    const url = `http://localhost:${PORT}`;
    exec(`start "" "${url}"`);
};

// Servir ficheiros locais (index.html, ajuste.css, etc.)
app.use(express.static(__dirname_actual));

// Proxy para buscar página externa e injetar CSS
app.get("/proxy", async (req, res) => {
    const targetUrl = req.query.url;
    if (!targetUrl) return res.status(400).send("Falta o parâmetro ?url=");

    try {
        const response = await fetch(targetUrl);
        let html = await response.text();

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

// Iniciar servidor e abrir browser
app.listen(PORT, () => {
    console.log(`Servidor ativo em http://localhost:${PORT}`);
    openBrowser();
});