import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingStatusPage extends StatefulWidget {
  const BookingStatusPage({super.key});

  @override
  State<BookingStatusPage> createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Status'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user_race_track_booking').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var booking = snapshot.data!.docs[index];
              return ListTile(
                title: Text('Booking ID: ${booking.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Slot: ${booking['selectedSlot']}'),
                    Text('Payment Option: ${booking['selectedPaymentOption']}'),
                    Text('Status: ${booking['status']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}