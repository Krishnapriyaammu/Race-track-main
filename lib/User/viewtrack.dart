import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginrace/User/viewchallengess.dart';

class ViewTrack extends StatefulWidget {
  String rt_id;
   ViewTrack({super.key, required this. rt_id});

  @override
  State<ViewTrack> createState() => _ViewTrackState();
}

class _ViewTrackState extends State<ViewTrack> {

    Future<List<DocumentSnapshot>> getdata() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('race_track_add_track').where('uid',isEqualTo: widget.rt_id)
          .get();
          
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
     
    } catch (e) {
      print('Error fetching data: $e');
      throw e; 
    }
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
     
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: FutureBuilder(
          future: getdata(),
          builder: (context,AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<DocumentSnapshot> documents = snapshot.data!;
              if (documents.isEmpty) {
                return Center(child: Text('No track details available'));
              }
              final trackData = documents.first.data() as Map<String, dynamic>;
              return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Center(
                  child: Image.network(
                      trackData['image_url'],
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                ),
                SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trackData['track'] ?? 'Track Name Not Available',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(height: 12),
                          Divider(color: Colors.white),
                          SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Surface',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                trackData['surface'] ?? 'Surface Details Not Available',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Length',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                trackData['length'] ?? 'Track Length Not Available',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Turns',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                trackData['turns'] ?? 'Turns Not Available',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Race lap record',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                               Text(
                                trackData['record'] ?? 'Race Lap Record Not Available',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
       floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to the page to view challenges
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserViewChallenges()),
              );
            },
            icon: Icon(Icons.account_tree_outlined),
            label: Text('View Challenges'),
          ),
        ],
      ),
    );
  }
}