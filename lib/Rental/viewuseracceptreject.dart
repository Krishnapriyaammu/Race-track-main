import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/Rental/viewaccepatrequestrental.dart';

class ViewUserAccept extends StatefulWidget {
  String documentId;
   ViewUserAccept({super.key, required this. documentId});

  @override
  State<ViewUserAccept> createState() => _ViewUserAcceptState();
}

class _ViewUserAcceptState extends State<ViewUserAccept> {
   bool isApproved = false;
  bool isRejected = false;

  Future<Map<String, dynamic>> getUserBookingData() async {
    try {
      final userBookingSnapshot = await FirebaseFirestore.instance
          .collection('user_rent_booking')
          .doc(widget.documentId)
          .get();

      final imageSnapshot = await FirebaseFirestore.instance
          .collection('rental_upload_image')
          .get();

      if (userBookingSnapshot.exists && imageSnapshot.docs.isNotEmpty) {
        final userBookingData = userBookingSnapshot.data() as Map<String, dynamic>;
        final imageData = imageSnapshot.docs.first.data() as Map<String, dynamic>;
        final bookingDate = userBookingData['booking_date'];
        final status = userBookingData['status'];

        return {
          'userBookingData': userBookingData,
          'imageData': imageData,
          'bookingDate': bookingDate,
          'status': status,
        };
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getUserBookingData(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Data not available'));
            } else {
              final userBookingData = snapshot.data!['userBookingData'];
              final imageData = snapshot.data!['imageData'];
              final status = snapshot.data!['status'];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageData['image_url']),
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      userBookingData['name'] ?? 'Name not available',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        userBookingData['address'] ?? 'Address not available',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        userBookingData['mobile no'] ?? 'Mobile number not available',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        imageData['description'] ?? 'Description not available',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: snapshot.data!['bookingDate'] != null
                          ? Text(
                              'Booking date: ${formatDate(snapshot.data!['bookingDate'])}',
                              style: TextStyle(fontSize: 16),
                            )
                          : Text(
                              'Booking date not available',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    SizedBox(height: 10),
                  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Due date:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5), // Adjust spacing as needed
      Text(
        userBookingData['due_date'] ?? 'Due date not available',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    ],
  ),
),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageData['image_url'] ?? 'Image not available',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (status == 1)
                      Text(
                        'Status: Approved',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: isApproved
                              ? null
                              : () {
                                  setState(() {
                                    isApproved = true;
                                  });
                                },
                          child: Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isApproved ? Colors.grey : Colors.green,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: isApproved
                              ? null
                              : () {
                                  setState(() {
                                    isRejected = true;
                                  });
                                },
                          child: Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isApproved ? Colors.grey : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}