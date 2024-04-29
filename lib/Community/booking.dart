import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingViewPage extends StatefulWidget {
  const BookingViewPage({super.key});

  @override
  State<BookingViewPage> createState() => _BookingViewPageState();
}

class _BookingViewPageState extends State<BookingViewPage> {
 late List<QueryDocumentSnapshot<Map<String, dynamic>>> bookingRequests = [];

  @override
  void initState() {
    super.initState();
    fetchBookingRequests();
  }

  Future<void> fetchBookingRequests() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('uid') ?? '';

      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('community_id', isEqualTo: id)
          .get();

      setState(() {
        bookingRequests = snapshot.docs;
      });

      print('Fetched ${bookingRequests.length} booking requests');
    } catch (e) {
      print('Error fetching booking requests: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
          .collection('community_register')
          .doc(userId)
          .get();

      final userDetails = userSnapshot.data() ?? {};
      print('Fetched user details for userId: $userId');

      return userDetails;
    } catch (e) {
      print('Error fetching user details for userId: $userId - $e');
      return {};
    }
  }

  Future<void> acceptBooking(String requestId) async {
    try {
      await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
        'status': 1, // 1 indicates booking accepted
      });
      print('Booking request accepted');
    } catch (e) {
      print('Error accepting booking request: $e');
    }
  }

  Future<void> cancelBooking(String requestId) async {
    try {
      await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
        'status': 2, // 2 indicates booking cancelled
      });
      print('Booking request cancelled');
    } catch (e) {
      print('Error cancelling booking request: $e');
    }
  }

  void handleAccept(String requestId) {
    acceptBooking(requestId);
    // Navigate to next page with bookingRequests list
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return DesignerProceed(bookingRequests: bookingRequests, bookingRequets: 'string',);
    // }));
  }

  void handleCancel(String requestId, int index) {
    cancelBooking(requestId);
    // Remove cancelled request from the list
    setState(() {
      bookingRequests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NOTIFICATIONS',
          style: TextStyle(color: Colors.deepPurpleAccent),
        ),
      ),
      body: ListView.builder(
        itemCount: bookingRequests.length,
        itemBuilder: (context, index) {
          final bookingRequest = bookingRequests[index].data(); // Get the data of the document
          final userId = bookingRequest['userid'];
          final requestId = bookingRequests[index].id; // Get the document ID

          return FutureBuilder(
            future: fetchUserDetails(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final userDetails = snapshot.data as Map<String, dynamic>;
                return Container(
                  height: 350,
                  width: 200,
                  margin: EdgeInsets.all(10),
                  color: Color(0xFFFFFFFF),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          userDetails.containsKey('image_url')
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(userDetails['image_url']),
                                  radius: 30,
                                )
                              : CircleAvatar(
                                  child: Icon(Icons.person),
                                  radius: 30,
                                ),
                          SizedBox(width: 20),
                          Text(userDetails['name'] ?? ''),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'email:',
                            style: TextStyle(color: Color.fromARGB(221, 83, 6, 77)),
                          ),
                          SizedBox(width: 5),
                          Text(userDetails['email'] ?? ''),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date : ${bookingRequest['date'] ?? ''}',
                            style: TextStyle(color: Color.fromARGB(255, 92, 8, 71)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Time : ${bookingRequest['time'] ?? ''}',
                            style: TextStyle(color: Color.fromARGB(255, 83, 4, 70)),
                          ),
                          SizedBox(height: 5),
                          FutureBuilder(
                            future: fetchUserDetails(userId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                final userDetails = snapshot.data as Map<String, dynamic>;
                                return Text(
                                  'Address : ${userDetails['address'] ?? ''}',
                                  style: TextStyle(color: Color.fromARGB(255, 83, 4, 70)),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: IconButton(
                              onPressed: () {
                                handleAccept(requestId);
                              },
                              icon: Icon(Icons.check),
                              color: Colors.deepPurple,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              handleCancel(requestId, index);
                            },
                            icon: Icon(Icons.cancel),
                            color: Colors.deepPurple,
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}