import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/Rental/rentelhome.dart';
class StatusTrack extends StatefulWidget {
String rt_id;
 String userId;
  StatusTrack({Key? key, required this. rt_id, required this.userId, }) : super(key: key);

  @override
  _StatusTrackState createState() => _StatusTrackState();
}
class _StatusTrackState extends State<StatusTrack> {
   String? selectedLevel = 'Level 1';
  String? status;


  Future<List<DocumentSnapshot>> getData() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_track_booking')
          .where('rt_id', isEqualTo: widget.rt_id).where('userid', isEqualTo: widget.userId)
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  void updateStatus(String documentId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_track_booking')
          .doc(documentId)
          .update({'status': status});
      print('Status updated successfully');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<DocumentSnapshot> documents = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: documents.map((DocumentSnapshot document) {
                      final String name = document['name'] ?? 'Name not available';
                      final String email = document['email'] ?? 'Email not available';
                      final String phone = document['phone'] ?? 'Phone not available';
                      final String place = document['place'] ?? 'Place not available';
                      status = document['status'] ?? 'not available'; // Assign status here
                      final String documentId = document.id;

                      return Column(
                        children: [
                          Text(
                            'Your Booking Details',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text('Name: $name'),
                          Text('Email: $email'),
                          Text('Phone: $phone'),
                          Text('Place: $place'),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: selectedLevel,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedLevel = newValue;
                              });
                            },
                            items: <String>[
                              'Level 1',
                              if (status == '1') 'Level 2' // Conditionally add 'Level 2' based on status
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                          onPressed: () {
                            if (status == '0' && selectedLevel == 'Level 1') {
                              updateStatus(documentId, '1');
                              setState(() {
                                status = '1';
                              });
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(status == '0' ? Colors.green : Colors.grey),
                          ),
                          child: Text(status == '0' ? '$selectedLevel Completed' : '$selectedLevel Completed'),
                        ),
                        SizedBox(height: 10),
                      if (status == '2') // Show message when status is 2
  Column(
    children: [
      Text(
        'You can now enroll Level 2',
        style: TextStyle(fontSize: 18, color: Colors.blue),
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity, // Full width
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8), // Adjust border radius as needed
        ),
        child: TextButton(
          onPressed: () {
            // Handle Level 2 button action
          },
          child: Text(
            'Enroll Level 2',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
                          ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    ),
  );
}
}