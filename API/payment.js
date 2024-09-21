require('dotenv').config(); // Load environment variables from .env file

const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

// Use the server key from environment variables

const MIDTRANS_SERVER_KEY = process.env.MIDTRANS_SERVER_KEY; 
console.log('MIDTRANS_SERVER_KEY:', MIDTRANS_SERVER_KEY); // Check if the key is loaded correctly
const MIDTRANS_URL = 'https://api.sandbox.midtrans.com/v2/charge';

app.post('/api/payment', async (req, res) => {
    const { orderId, amount, paymentType} = req.body;

    const payload = {
        payment_type: paymentType,
        transaction_details: {
            order_id: orderId,
            gross_amount: amount, // Tambahkan Merchant ID di sini
        },
    };

    try {
        const response = await axios.post(MIDTRANS_URL, payload, {
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Basic ${Buffer.from(MIDTRANS_SERVER_KEY + ':').toString('base64')}`,
            },
          });          
        res.json(response.data);
    } catch (error) {
        if (error.response) {
            console.error('Error response data:', error.response.data);
            console.error('Error response status:', error.response.status);
            res.status(error.response.status).json({ error: error.response.data });
        } 
        else {
            console.error('Error message:', error.message);
            res.status(500).json({ error: error.message });
        }
    }
});

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});