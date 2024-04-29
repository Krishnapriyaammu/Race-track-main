import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventBookingDetails extends StatefulWidget {
  String rt_id;
   EventBookingDetails({super.key, required this. rt_id});

  @override
  State<EventBookingDetails> createState() => _EventBookingDetailsState();
}

class _EventBookingDetailsState extends State<EventBookingDetails> {
  @override
   Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: Colors.blueAccent, // Customize app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _getBookingDetails(), // Function to retrieve booking details
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Process snapshot data and display booking details
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var bookingData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return Card(
                    elevation: 4, // Add elevation to the card for a raised effect
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      // Remove leading icon
                      leading: null,
                      title: Text(
                        'Name: ${bookingData['name'] ?? 'Unknown'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Child Tickets: ${bookingData['childTickets'] ?? 0}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'General Tickets: ${bookingData['generalTickets'] ?? 0}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Total Tickets: ${bookingData['totalTickets'] ?? 0}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                      onTap: () {
                        // Handle tap on booking details
                        // You can add navigation to a detailed view if needed
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Function to retrieve booking details from Firestore
  Future<QuerySnapshot> _getBookingDetails() async {
    try {
      return await FirebaseFirestore.instance
          .collection('Eventtickets')
          .where('rt_id', isEqualTo: widget.rt_id) // Filter by event ID
          .get();
    } catch (e) {
      print('Error fetching booking details: $e');
      throw e;
    }
  }
}