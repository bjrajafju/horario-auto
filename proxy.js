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
        let html = await (await fetch(targetUrl)).text();

        // Remover qualquer elemento que contenha a palavra "impressão"
        html = html.replace(/<[^>]+>[^<]*impressão[^<]*<\/[^>]+>/gi, "");

        // Injetar CSS
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

// Endpoint para devolver o link mais recente do dia
app.get("/latest", async (req, res) => {
    const weekday = req.query.day; // 0 = domingo, 1 = segunda, etc.
    if (weekday === undefined) return res.status(400).send("Falta ?day=");

    const folderUrl =
        "https://ispgaya.bulletscheduling.com/Corporate/Classrooms/";

    try {
        const response = await fetch(folderUrl);
        const html = await response.text();

        // Procurar ficheiros do tipo diario2_YYYYMMDD_X_DiaSemana.html
        const regex = new RegExp(`diario2_\\d+_${weekday}_.+?\\.html`, "g");
        const matches = html.match(regex);

        if (!matches || matches.length === 0) {
            return res
                .status(404)
                .send("Nenhum ficheiro encontrado para este dia.");
        }

        // Ordenar alfabeticamente (YYYYMMDD garante ordem correta) e pegar o último
        matches.sort();
        const latest = matches[matches.length - 1];

        res.json({ url: folderUrl + latest });
    } catch (err) {
        console.error("Erro ao obter lista:", err);
        res.status(500).send("Erro ao processar pedido.");
    }
});

// Iniciar servidor e abrir browser
app.listen(PORT, () => {
    console.log(`Servidor ativo em http://localhost:${PORT}`);
    openBrowser();
});
