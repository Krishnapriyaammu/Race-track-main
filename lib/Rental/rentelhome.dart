import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginrace/Rental/rentalviewprofile.dart';
import 'package:loginrace/Rental/rentnotification.dart';
import 'package:loginrace/Rental/viewuseracceptreject.dart';
import 'package:loginrace/User/rentnotificationuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentalHome extends StatefulWidget {
  const RentalHome({super.key});

  @override
  State<RentalHome> createState() => _RentalHomeState();
}

class _RentalHomeState extends State<RentalHome> {
  final TextEditingController _messageController = TextEditingController();

  Future<List<DocumentSnapshot>> getData() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_rent_booking')
          .get();

      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  final List<Tab> _tabs = [
    Tab(text: 'Requests'),
    Tab(text: 'Accepted'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rental Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.line_weight_outlined),
              onPressed: () {
                print("IconButton pressed"); // Temporary print statement
                _showPopupMenu(context);
              },
            ),
          ],
          bottom: TabBar(
            tabs: _tabs,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Colors.blue,
            ),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestsTab(),
            _buildAcceptedTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Expanded(
      child: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final document = snapshot.data![index];
                final data = document.data() as Map<String, dynamic>;

                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ViewUserAccept(documentId: document.id,);
                    }));
                  },
                  child: Card(
                    margin: EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${data['name'] ?? 'Name not available'}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Address: ${data['address'] ?? 'Address not available'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Mobile No: ${data['mobile no'] ?? 'Number not available'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Due Date: ${data['due_date'] ?? 'Due date not available'}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
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

  Future<List<DocumentSnapshot>> getAcceptedData() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_rent_booking')
          .where('status', isEqualTo: 1) // Fetch only documents where status is 1
          .orderBy('due_date', descending: false) // Order by due_date in ascending order
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

Widget _buildAcceptedTab() {
  return Expanded(
    child: FutureBuilder(
      future: getAcceptedData(),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final document = snapshot.data![index];
              final data = document.data() as Map<String, dynamic>;
              final documentId = document.id; // Get the booking ID

              return Card(
                margin: EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name: ${data['name'] ?? 'Name not available'}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Send notification
                              _sendNotification(documentId);
                            },
                            child: Text('Send Notification'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Address: ${data['address'] ?? 'Address not available'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Mobile No: ${data['mobile no'] ?? 'Number not available'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Due Date: ${data['due_date'] ?? 'Due date not available'}',
                        style: TextStyle(fontSize: 16),
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

void _sendNotification(String documentId) {
  FirebaseFirestore.instance
      .collection('user_rent_booking')
      .doc(documentId)
      .get()
      .then((doc) {
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();
      if (data?['status'] == 1) {
        FirebaseFirestore.instance
            .collection('user_rent_booking')
            .doc(documentId)
            .collection('notifications')
            .add({
          'message': 'Due date is about to reach',
          'timestamp': Timestamp.now(),
        }).then((_) {
          // Show toast message when notification is sent successfully
          Fluttertoast.showToast(
            msg: 'Notification has been sent',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }).catchError((error) {
          print('Error sending notification: $error');
        });
      } else {
        print('Document status is not 1. Notification not sent.');
      }
    } else {
      print('Document does not exist. Notification not sent.');
    }
  }).catchError((error) {
    print('Error getting document: $error');
  });
}


  void _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(500, 80, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('View Profile'),
            onTap: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              String userId = sp.getString('uid') ?? '';
              print('UserID: $userId'); // Add this line for debugging

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RentViewProfile(userId: userId);
              }));
            },
          ),
        ),
      
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Handle logout action
              Navigator.pop(context);
            },
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
