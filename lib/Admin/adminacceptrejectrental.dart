import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAcceptrejectRental extends StatefulWidget {
  final Map<String, dynamic> userData;
  String documentId;
   AdminAcceptrejectRental({super.key, required this. userData, required this. documentId});

  @override
  State<AdminAcceptrejectRental> createState() => _AdminAcceptrejectRentalState();
}

class _AdminAcceptrejectRentalState extends State<AdminAcceptrejectRental> {
  late Stream<DocumentSnapshot> _rentalRegisterStream;

  @override
  void initState() {
    super.initState();
    _rentalRegisterStream = FirebaseFirestore.instance
        .collection('rentalregister')
        .doc(widget.documentId)
        .snapshots();
  }

  Future<void> updateStatus(String? documentId) async {
    try {
      print('Document ID: $documentId'); // Print documentId for debugging
      if (documentId != null) {
        await FirebaseFirestore.instance
            .collection('rentalregister')
            .doc(documentId)
            .update({'status': 1});
        print('Status updated successfully');
      } else {
        print('Document ID is null');
      }
    } catch (e) {
      print('Error updating status: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.userData;
    var imageUrl = userData['image_url'];

    print('User Data: $userData'); // Print userData for debugging

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: _rentalRegisterStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Placeholder for loading state
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              var status = snapshot.data?['status'] ?? 0;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (imageUrl != null)
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 50,
                      ),
                    ),
                  SizedBox(height: 20),
                  Text(
                    userData['name'] ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    userData['place'] ?? '',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    userData['mobile no'] ?? '',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          updateStatus(widget.documentId);
                        },
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement reject logic
                        },
                        child: Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: status == 1 ? Colors.grey : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}