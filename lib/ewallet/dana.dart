import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import 'dart:convert'; // Import for JSON encoding/decoding

class GoPayTopUpPage extends StatefulWidget {
  @override
  _GoPayTopUpPageState createState() => _GoPayTopUpPageState();
}

class _GoPayTopUpPageState extends State<GoPayTopUpPage> {
  String selectedAmount = ''; // Initialize selected amount variable
  final TextEditingController phoneController = TextEditingController(); // Controller for phone number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3A3A5A), // Color according to E-Wallet
        title: Text('TOPUP GOPAY'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: phoneController, // Use controller
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            Text(
              'Choose Amount',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color
              ),
            ),
            SizedBox(height: 16.0),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                _buildAmountCard('5.000', 'Rp6.200'),
                _buildAmountCard('10.000', 'Rp11.200'),
                _buildAmountCard('25.000', 'Rp24.200'),
                _buildAmountCard('50.000', 'Rp46.200'),
                _buildAmountCard('75.000', 'Rp76.200'),
                _buildAmountCard('100.000', 'Rp96.200'),
              ],
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 44, 44, 67), // Button color
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                if (selectedAmount.isNotEmpty && phoneController.text.isNotEmpty) {
                  _makePayment(); // Call the payment function
                } else {
                  // Show error message if amount or phone number is not selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an amount and enter your phone number.')),
                  );
                }
              },
              child: Center(
                child: Text('CONTINUE', style: TextStyle(color: Colors.white)), // Button text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(String credits, String price) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = credits; // Update selectedAmount when card is tapped
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 20,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white, // Card background color
          border: Border.all(
            color: selectedAmount == credits ? Colors.redAccent : Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CREDITS $credits',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Price $price',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePayment() async {
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString(); // Create a unique order ID
    final double amount = double.parse(selectedAmount.replaceAll('.', '')) * 1.24; // Convert to appropriate amount

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/payment'), // Replace with your backend URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'orderId': orderId,
          'amount': amount,
          'paymentType': 'gopay', // Change to desired payment type
          'phoneNumber': phoneController.text, // Add phone number
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Payment successful: $data');
        // Process payment data here
        print(data);
        // Show success message or navigate to success page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful!')),
        );
      } else {
        print('Payment failed: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${response.body}')),
        );
      }
    } catch (error) {
      // Handle any exceptions
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }
}
