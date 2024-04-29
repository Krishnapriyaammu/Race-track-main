import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PayementAutoshow extends StatefulWidget {
  String price;
  String name;
  String community_id;
  
  PayementAutoshow({Key? key, required this.price, required this.name, required this.community_id}) : super(key: key);

  @override
  State<PayementAutoshow> createState() => _PayementAutoshowState();
}

class _PayementAutoshowState extends State<PayementAutoshow> {
   String? _selectedPaymentMethod;
  List<String> _paymentMethods = ['Credit Card', 'Debit Card', 'PayPal', 'Google Pay'];
  bool _paymentSuccessful = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for ${widget.name}'),
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
                      'Name: ${widget.name}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Price: \$${widget.price}',
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
                      onPressed: () async {
                        // Simulate payment process (set a delay of 2 seconds)
                        setState(() {
                          _paymentSuccessful = true;
                        });

                        // Save payment details to Firestore
                        await FirebaseFirestore.instance.collection('autoshowpayments').add({
                          'community_id': widget.community_id,
                          'amount': widget.price,
                          'type_of_payment': _selectedPaymentMethod,
                          'status': _paymentSuccessful ? 'Successful' : 'Failed',
                          'name': widget.name,
                        }).then((value) {
                          print("Payment details saved successfully!");
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