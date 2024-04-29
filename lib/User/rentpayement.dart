import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RentPayment extends StatefulWidget {
  String rent_id;
    final double price;
      final VoidCallback onPaymentSuccess; // Callback to notify payment success


   RentPayment({super.key, required this. rent_id, required this. price, required this. onPaymentSuccess});

  @override
  State<RentPayment> createState() => _RentPaymentState();
}

class _RentPaymentState extends State<RentPayment> {
   String? _selectedPaymentMethod;
  List<String> _paymentMethods = ['Credit Card', 'Debit Card', 'PayPal', 'Google Pay'];
  bool _paymentSuccessful = false;

  late String _name = '';
  late String _address = '';
  late int _quantity = 0;
  late int _price = 0;

  Future<void> fetchData() async {
    try {
      final userRentBookingSnapshot = await FirebaseFirestore.instance
          .collection('user_rent_booking')
          .where('rent_id', isEqualTo: widget.rent_id)
          .get();

      if (userRentBookingSnapshot.docs.isNotEmpty) {
        final userRentBookingData = userRentBookingSnapshot.docs.first.data();
        setState(() {
          _name = userRentBookingData['name'] ?? ''; // Adding null check
          _address = userRentBookingData['address'] ?? ''; // Adding null check
          _quantity = userRentBookingData['quantity'] ?? 0; // Adding null check
        });
      } else {
        print('No booking data found for rent_id: ${widget.rent_id}');
      }

      _price = widget.price.toInt(); // Convert double to int using toInt()

    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Your payment has been successfully processed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onPaymentSuccess();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for $_name'),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: _paymentSuccessful
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.blue, size: 100),
                  SizedBox(height: 20),
                  Text(
                    'Payment Successful!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Name: $_name',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Address: $_address',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Quantity: $_quantity',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Price: \$$_price',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Choose Payment Method:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 12),
                    DropdownButton<String>(
                      value: _selectedPaymentMethod,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                      },
                      items: _paymentMethods.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // Simulate payment process (set a delay of 2 seconds)
                        setState(() {
                          _paymentSuccessful = true;
                        });

                        // Save payment details to Firestore
                        FirebaseFirestore.instance.collection('rent_payment').add({
                          'name': _name,
                          'address': _address,
                          'quantity': _quantity,
                          'price': _price,
                          'paymentMethod': _selectedPaymentMethod,
                          'rent_id': widget.rent_id,
                          'status': 0,
                        }).then((value) {
                          print("Payment details saved successfully!");
                          // Notify parent page about payment success
                          widget.onPaymentSuccess();
                          _showPaymentSuccessDialog();
                        }).catchError((error) {
                          print("Failed to save payment details: $error");
                        });

                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            _paymentSuccessful = false;
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        child: Text(
                          'Pay',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}