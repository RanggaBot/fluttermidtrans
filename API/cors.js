const express = require('express');
const request = require('request');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*"); // Allow all origins
    next();
});

app.get('/proxy', (req, res) => {
    const url = req.query.url;
    request({ url }).pipe(res);
});

app.listen(PORT, () => {
    console.log(`CORS Proxy running on port ${PORT}`);
});