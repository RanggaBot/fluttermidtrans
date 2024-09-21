import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class GoPayPage extends StatefulWidget {
  @override
  _GoPayPageState createState() => _GoPayPageState();
}

class _GoPayPageState extends State<GoPayPage> {
  final TextEditingController _nomorController = TextEditingController();
  int? _selectedSaldo;
  bool _isLoading = false;
  String? _qrUrl; // Menyimpan URL QR setelah pembayaran berhasil

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('TOPUP DANA'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Isi Ulang DANA',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5)),
                ],
              ),
              child: TextField(
                controller: _nomorController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  labelText: 'Masukkan Nomor',
                  hintText: 'Contoh: 08123456789',
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5)),
                ],
              ),
              child: DropdownButton<int>(
                isExpanded: true,
                hint: Text('Pilih Saldo'),
                value: _selectedSaldo,
                items: [
                  100000,
                  200000,
                  300000,
                  400000,
                  500000,
                  600000,
                  700000,
                  800000,
                  900000,
                  1000000
                ].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('Rp. $value'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedSaldo = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_nomorController.text.isNotEmpty &&
                            _selectedSaldo != null) {
                          _showPaymentOptions();
                        } else {
                          _showSnackbar('Nomor dan saldo harus diisi.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Lanjutkan Pembayaran',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
            ),
            // Tampilkan QR jika sudah tersedia
            if (_qrUrl != null) ...[
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Scan QR Code untuk Melanjutkan Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Image.network(_qrUrl!, width: 200, height: 200),
                            );
                          },
                        );
                      },
                      child: Text('Tampilkan QR'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPaymentOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Pilih Metode Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Image.asset('assets/gopay.png', width: 40),
                  title: Text('GoPay'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _prosesPembayaran('gopay');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _prosesPembayaran(String paymentMethod) async {
    setState(() {
      _isLoading = true;
    });

    final nomor = _nomorController.text;
    final saldo = _selectedSaldo;

    const String url = 'http://localhost:3000/payment';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nomor": nomor,
          "saldo": saldo,
          "payment_type": paymentMethod,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData['qrUrl'] != null) {
          setState(() {
            _qrUrl = responseData['qrUrl']; // Set QR URL untuk ditampilkan
          });
          _startPaymentStatusCheck(responseData['order_id']);
        } else {
          _showSnackbar('URL pembayaran tidak tersedia');
        }
      } else {
        _showSnackbar('Gagal memproses pembayaran');
      }
    } catch (error) {
      _showSnackbar('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startPaymentStatusCheck(String orderId) {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      final response = await http
          .get(Uri.parse('http://localhost:3000/payment-status/$orderId'));

      if (response.statusCode == 200) {
        final paymentStatus = jsonDecode(response.body);
        if (paymentStatus['transaction_status'] == 'settlement') {
          timer.cancel();
          _showSuccessDialog();
        } else if (paymentStatus['transaction_status'] == 'failed') {
          timer.cancel();
          _showFailureDialog();
        }
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pembayaran Berhasil'),
          content: Text('Pembayaran Anda telah berhasil diproses.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pembayaran Gagal'),
          content: Text('Pembayaran Anda tidak berhasil. Silakan coba lagi.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
