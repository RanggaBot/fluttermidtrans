import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Tambahkan import untuk http
import 'dart:convert'; // Tambahkan import untuk json

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = ''; // Untuk menyimpan metode pembayaran yang dipilih

  // Daftar metode pembayaran yang tersedia
  final List<Map<String, String>> paymentMethods = [
    {'name': 'GoPay', 'icon': 'assets/icons/gopay.png'},
    {'name': 'Bank Transfer', 'icon': 'assets/icons/bca.png'},
    {'name': 'DANA', 'icon': 'assets/icons/dana.png'},
    {'name': 'CIMB', 'icon': 'assets/icons/cimb.png'},
    {'name': 'Bri', 'icon': 'assets/icons/bri.png'},
    {'name': 'Bni', 'icon': 'assets/icons/bni.png'},
    // Tambahkan metode pembayaran baru
    {'name': 'OVO', 'icon': 'assets/icons/ovo.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3A3A5A), // Warna AppBar
        title: Text('Pilih Metode Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  return _buildPaymentMethodCard(
                    paymentMethods[index]['name']!,
                    paymentMethods[index]['icon']!,
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3A3A5A),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                if (selectedPaymentMethod.isNotEmpty) {
                  // Panggil fungsi pembayaran disini
                  _makePayment();
                } else {
                  // Tampilkan pesan jika metode pembayaran belum dipilih
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu')),
                  );
                }
              },
              child: Center(
                child: Text(
                  'LANJUTKAN PEMBAYARAN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String methodName, String iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = methodName; // Perbarui metode pembayaran yang dipilih
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: selectedPaymentMethod == methodName ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: selectedPaymentMethod == methodName ? Colors.blue : Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 40.0, width: 40.0), // Gambar icon metode pembayaran
            SizedBox(width: 16.0),
            Text(
              methodName,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePayment() async {
    // Simulasi pemanggilan API pembayaran
    print('Melakukan pembayaran dengan metode: $selectedPaymentMethod');

    // URL backend untuk memanggil API Midtrans
    String backendUrl = 'https://your-backend-url.com/midtrans'; // Ganti dengan URL backend Anda

    // Panggil API pembayaran (menggunakan http)
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': selectedPaymentMethod,
        // Tambahkan parameter lain yang diperlukan oleh API
      }),
    );

    if (response.statusCode == 200) {
      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembayaran berhasil menggunakan $selectedPaymentMethod')),
      );
    } else {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembayaran gagal: ${response.body}')),
      );
    }
  }
}

class MidtransPage extends StatelessWidget {
    final String? selectedNumber;
    final int? selectedAmount;

    MidtransPage({this.selectedNumber, this.selectedAmount});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Pembayaran"),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text("Nomor: ${selectedNumber ?? 'N/A'}"), // Menangani null
                        Text("Jumlah: Rp ${selectedAmount ?? 0}"), // Menangani null
                        ElevatedButton(
                            onPressed: () {
                                // Logika untuk menampilkan QR code
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));
                            },
                            child: Text("Bayar"),
                        ),
                    ],
                ),
            ),
        );
    }
}

