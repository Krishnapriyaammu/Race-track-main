import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachBookingStatus extends StatefulWidget {
  
  var img;
   String coach_id;
   String rt_id;
   
   CoachBookingStatus({super.key, required this.img, required this. coach_id, required this. rt_id,  });

  @override
  State<CoachBookingStatus> createState() => _CoachBookingStatusState();
}

class _CoachBookingStatusState extends State<CoachBookingStatus> {
   Future<Map<String, dynamic>> getdata() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('coachbooking')
          .where('coach_id', isEqualTo: widget.coach_id)
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      if (snapshot.docs.isNotEmpty) {
        final document = snapshot.docs.first;
        final data = document.data() as Map<String, dynamic>;
        return {
          'date': data['date'],
          'time': data['time'],
          'level': data['level'],
          'status': data['status'],
        };
      } else {
        return {
          'date': null,
          'time': null,
          'level': null,
          'status': null,
        };
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<void> _sendFeedback() async {
    String feedback = ''; // Initialize feedback variable

    // Show dialog to get feedback
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Feedback'),
          content: TextField(
            onChanged: (value) {
              feedback = value; // Update feedback when text changes
            },
            decoration: InputDecoration(hintText: 'Enter feedback'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
           TextButton(
            child: Text('Submit'),
            onPressed: () async {
              // Store feedback, userid, and coach_id in Firebase
              SharedPreferences sp = await SharedPreferences.getInstance();
              String userId = sp.getString('uid') ?? '';
              String coachId = widget.coach_id;
              String rt_id = widget.rt_id;

              // Verify that rt_id is not null or empty
             if (feedback.isNotEmpty && rt_id.isNotEmpty) {
  await FirebaseFirestore.instance.collection('feedback').add({
    'userId': userId,
    'coachId': coachId,
    'feedback': feedback,
    'rt_id': rt_id,
  });
} else {
  print('Feedback or rt_id is empty.');
              }

              // Close dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coach Booking Status'),
      ),
      body: Center(
        child: FutureBuilder(
          future: getdata(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final data = snapshot.data!;
              final status = data['status'];
              final statusText = status == 1 ? 'Approved' : 'Not approved';
              final color = status == 1 ? Colors.green : Colors.red;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: widget.img.isNotEmpty
                              ? Image.network(
                                  widget.img,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image),
                        ),
                      ),
                    ),
                    Text(
                      data['date'] ?? 'Date not available',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data['time'] ?? 'Time not available',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data['level'] ?? 'Level not available',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          statusText,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (status == 1)
                     ElevatedButton(
  onPressed: () {
    print('rt_id: ${widget.rt_id}');
    _sendFeedback();
  },
  child: Text('Send Feedback'),
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