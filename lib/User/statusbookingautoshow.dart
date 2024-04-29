import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/User/payementauto.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AutoShowStatus extends StatefulWidget {
    final String category;
  final String price;
  String community_id;

   AutoShowStatus({super.key, required this. price, required this. category, required this. community_id});

  @override
  State<AutoShowStatus> createState() => AutoShowStatusState();
}

class AutoShowStatusState extends State<AutoShowStatus> {
   Future<List<DocumentSnapshot>> getBookings() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('auto_show_booking')
              .where('community_id', isEqualTo: widget.community_id) // Filter by community_id

      .get();
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<bool> isPaid(String community_id) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('autoshowpayments')
          .where('community_id', isEqualTo: community_id)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final paymentData = snapshot.docs.first.data() as Map<String, dynamic>;
        return paymentData['status'] == 'Successful';
      }
      return false;
    } catch (e) {
      print('Error fetching payment status: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: FutureBuilder(
        future: getBookings(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var bookingData = snapshot.data![index].data() as Map<String, dynamic>;
                int status = bookingData['status'];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category Choosen: ${bookingData['category']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Price: ${widget.price}', style: TextStyle(fontWeight: FontWeight.bold)), // Display the price here
                        Text('Name: ${bookingData['name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.0),
                        Text('Place: ${bookingData['place']}'),
                        Text('Phone Number: ${bookingData['phone_number']}'),
                        Text('Date: ${bookingData['date']} '),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (status == 0) // Assuming 0 represents 'Pending' status
                              ElevatedButton(
                                onPressed: () {
                                  // Handle pending button action
                                },
                                child: Text('Pending'),
                              )
                            else
                              ElevatedButton(
                                onPressed: () {
                                  // Handle approve button action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text('Approved'),
                              ),
                            SizedBox(width: 8.0),
                            if (status == 1) // Only show payment button if status is approved
                              FutureBuilder<bool>(
                                future: isPaid(bookingData['community_id']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final bool isPaid = snapshot.data ?? false;

                                    return ElevatedButton(
                                      onPressed: isPaid ? null : () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return PayementAutoshow(
                                            name: bookingData['name'],
                                            price: widget.price,
                                            community_id: widget.community_id,
                                          );
                                        }));
                                      },
                                      child: Text(isPaid ? 'Paid' : 'Payment'),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}