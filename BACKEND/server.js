const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());
app.use(cors());


const MIDTRANS_SERVER_KEY = 'SB-Mid-server-rqAwNZTMWOEMOeppOdY2TemX';
const MIDTRANS_API_URL = 'https://api.sandbox.midtrans.com/v2/charge';


app.post('/payment', async (req, res) => {
  const { nomor, saldo, payment_type } = req.body;

  const validPaymentTypes = ['gopay']; 
  if (!nomor || !saldo || !payment_type || !validPaymentTypes.includes(payment_type)) {
    return res.status(400).json({ error: 'Nomor, saldo, dan payment_type wajib diisi dan harus valid' });
  }

  const transactionDetails = {
    payment_type: payment_type,
    transaction_details: {
      order_id: `order-${Date.now()}`,
      gross_amount: saldo,
    },
    customer_details: {
      first_name: 'User',             
      email: 'user@example.com',       
      phone: nomor,
    },
  };

  try {
    const response = await axios.post(MIDTRANS_API_URL, transactionDetails, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Basic ${Buffer.from(MIDTRANS_SERVER_KEY).toString('base64')}`,
      },
    });

    console.log('Midtrans Response:', response.data); // Menambahkan log untuk melihat response dari Midtrans

    const qrAction = response.data.actions.find(action => action.name === 'generate-qr-code');
    if (qrAction && qrAction.url) {
      return res.status(201).json({ qrUrl: qrAction.url, order_id: transactionDetails.transaction_details.order_id });
    } else {
      return res.status(500).json({ error: 'URL QR tidak ditemukan' });
    }
  } catch (error) {
    console.error('Error processing payment:', error.response ? error.response.data : error.message);
    console.error('Request Data:', transactionDetails); // Menambahkan logging untuk data permintaan
    res.status(500).json({ error: 'Pembayaran gagal diproses' });
  }
});

// Handle Midtrans payment notification
app.post('/payment-notification', async (req, res) => {
  const notification = req.body;
  console.log('Payment Notification:', notification);
  res.status(200).send('OK');
});

// Check payment status
app.get('/payment-status/:orderId', async (req, res) => {
  const orderId = req.params.orderId;
  const url = `https://api.sandbox.midtrans.com/v2/${orderId}/status`;

  try {
    const response = await axios.get(url, {
      headers: {
        'Authorization': `Basic ${Buffer.from(MIDTRANS_SERVER_KEY).toString('base64')}`,
      },
    });
    res.status(200).json(response.data);
  } catch (error) {
    console.error('Error fetching payment status:', error.response ? error.response.data : error.message);
    res.status(500).json({ error: 'Gagal memeriksa status pembayaran' });
  }
});

// Proxy endpoint
app.get('/proxy/:id', async (req, res) => { // Menambahkan parameter id
  const url = `https://api.sandbox.midtrans.com/v2/gopay/${req.params.id}/qr-code`;
  try {
    const response = await axios.get(url); // Menggunakan axios untuk mendapatkan QR code
    res.setHeader('Access-Control-Allow-Origin', '*'); // Menambahkan header CORS
    res.status(response.status).json(response.data);
  } catch (error) {
    console.error('Error fetching QR code:', error.response ? error.response.data : error.message);
    res.status(500).json({ error: 'Gagal mengambil QR code' });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
