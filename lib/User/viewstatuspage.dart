import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/User/rentnotificationuser.dart';
import 'package:loginrace/User/rentpayement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewStatusPage extends StatefulWidget {
  String rent_id;
  final String price; // New parameter for price
  String documentId;

  ViewStatusPage(
      {super.key,
      required this.rent_id,
      required this.price,
      required this.documentId, });

  @override
  State<ViewStatusPage> createState() => _ViewStatusPageState();
}

class _ViewStatusPageState extends State<ViewStatusPage> {
 late List<Map<String, dynamic>> _bookingData;
  bool isBookingPaid = false;

  @override
  void initState() {
    super.initState();
    _bookingData = [];
    getBookingData();
  }

  Future<void> getBookingData() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var userId = sp.getString('uid');

      final QuerySnapshot<Map<String, dynamic>> bookingSnapshot =
          await FirebaseFirestore.instance
              .collection('user_rent_booking')
              .where('userid', isEqualTo: userId)
              .where('rent_id', isEqualTo: widget.rent_id)
              .get();

      if (bookingSnapshot.docs.isNotEmpty) {
        setState(() {
          _bookingData = bookingSnapshot.docs.map((doc) {
            print('Booking Doc ID: ${doc.id}'); // Print doc.id

            var data = doc.data();
            data['docId'] = doc.id; // Assign docId to booking data
            return data;
          }).toList();
        });
      } else {
        print('No booking data found for rent_id: ${widget.rent_id}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details '),
        actions: [
          
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: _bookingData.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _bookingData.map((booking) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name: ${booking['name'] ?? 'Not available'}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {

 Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RentNotificationUser(      
                    bookingDocId: booking['docId'], // Pass the booking document ID
);
              }));



                              },
                              icon: Icon(Icons.notifications),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Phone Number: ${booking['mobile no'] ?? 'Not available'}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Due Date: ${booking['due_date'] ?? 'Not available'}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
  'Price: ${booking['total_price']}', // Display price
  style: TextStyle(fontSize: 16.0),
),
                        SizedBox(height: 8.0),

Text(
  'Quantity: ${booking['quantity']}', // Display quantity
  style: TextStyle(fontSize: 16.0),
),
                        SizedBox(height: 8.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isBookingPaid) ...[
                              if (booking['status'] == 0)
                                ElevatedButton(
                                  onPressed: () {
                                    // Add action for pending button
                                  },
                                  child: Text('Pending'),
                                )
                              else if (booking['status'] == 1)
                                ElevatedButton(
                                  onPressed: () {
                                 
                                  },
                                  child: Text('Payment'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _showDeleteConfirmationDialog(
                                      context, booking['docId']);
                                  // log(_bookingData);
                                },
                                child: Text('Cancel Booking'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                            if (isBookingPaid) ...[
                              Text(
                                'Paid',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String? docId) {
    print('Booking Doc ID: $docId'); // Print the docId

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to cancel this booking?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteBooking(context, docId);
              },
              child: Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

Future<void> _deleteBooking(BuildContext context, String? docId) async {
  try {
    // Delete booking from Firestore
    await FirebaseFirestore.instance
        .collection('user_rent_booking')
        .doc(docId)
        .delete();

    // Remove booking from local list
    setState(() {
      _bookingData.removeWhere((booking) => booking['docId'] == docId);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Booking canceled')));
  } catch (e) {
    print('Error deleting booking: $e');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Failed to cancel booking')));
  }
}
}