const express = require('express');
const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.json());

app.post('/midtrans/callback', (req, res) => {
    const notification = req.body;
    // Proses notifikasi di sini
    console.log(notification);
    res.sendStatus(200); // Kirim respons 200 OK
});

app.listen(3000, () => {
    console.log('Server berjalan di port 3000');
});