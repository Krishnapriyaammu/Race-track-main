import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RentNotificationUser extends StatefulWidget {
  String bookingDocId;
   RentNotificationUser({super.key,   required  this.bookingDocId});

  @override
  State<RentNotificationUser> createState() => _RentNotificationUserState();
}

class _RentNotificationUserState extends State<RentNotificationUser> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('user_rent_booking')
            .doc(widget.bookingDocId)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications'));
          } else {
            final message = snapshot.data!.docs.first['message'];
            final timestamp = snapshot.data!.docs.first['timestamp'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                            SizedBox(height: 10),
                            Text(
                              message,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Received at: ${_formatTimestamp(timestamp)}',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}