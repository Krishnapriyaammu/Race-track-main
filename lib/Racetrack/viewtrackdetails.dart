import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaceTrackViewTrackdetails extends StatefulWidget {
  String uid;
  String trackId;
   RaceTrackViewTrackdetails({super.key,  required this. uid, required this. trackId});

  @override
  State<RaceTrackViewTrackdetails> createState() => _RaceTrackViewTrackdetailsState();
}

class _RaceTrackViewTrackdetailsState extends State<RaceTrackViewTrackdetails> {
   late Future<DocumentSnapshot> trackDetails;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    trackDetails = fetchTrackDetails();
  }

  Future<DocumentSnapshot> fetchTrackDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('race_track_add_track')
          .doc(widget.trackId)
          .get();
      setState(() {
        data = snapshot.data() as Map<String, dynamic>?; // Assign snapshot data to data variable
      });
      return snapshot;
    } catch (e) {
      print('Error fetching track details: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Details'),
        actions: [
          IconButton(
            onPressed: () {
              _showEditDialog(context);
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: trackDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || data == null) {
              return Center(child: Text('No data found'));
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'OUR TRACK',
                      style: GoogleFonts.getFont('Inter', fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Image.network(data!['image_url'] ?? ''),
                  ),
                  Container(
                    height: 30,
                    width: 400,
                    color: Color.fromARGB(255, 58, 57, 57),
                    child: Text(
                      data!['track'] ?? '',
                      style: GoogleFonts.getFont('Inter', fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  infoRow('Surface', data!['surface'] ?? ''),
                  infoRow('Length', data!['length'] ?? ''),
                  infoRow('Turns', data!['turns'] ?? ''),
                  infoRow('Race lap record', data!['record'] ?? ''),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Track Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: data!['surface'] ?? '',
                  decoration: InputDecoration(labelText: 'Surface'),
                  onChanged: (value) {
                    setState(() {
                      data!['surface'] = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: data!['length'] ?? '',
                  decoration: InputDecoration(labelText: 'Length'),
                  onChanged: (value) {
                    setState(() {
                      data!['length'] = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: data!['turns'] ?? '',
                  decoration: InputDecoration(labelText: 'Turns'),
                  onChanged: (value) {
                    setState(() {
                      data!['turns'] = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: data!['record'] ?? '',
                  decoration: InputDecoration(labelText: 'Race lap record'),
                  onChanged: (value) {
                    setState(() {
                      data!['record'] = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('race_track_add_track')
                    .doc(widget.trackId)
                    .update(data!);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}