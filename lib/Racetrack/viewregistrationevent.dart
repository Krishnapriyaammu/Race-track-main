import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewRegistration extends StatefulWidget {
  String rt_id;
   ViewRegistration({super.key, required this. rt_id});

  @override
  State<ViewRegistration> createState() => _ViewRegistrationState();
}

class _ViewRegistrationState extends State<ViewRegistration> {
   late Future<List<DocumentSnapshot>> _registrationsFuture;

  @override
  void initState() {
    super.initState();
    _registrationsFuture = fetchRegistrations();
  }

  Future<List<DocumentSnapshot>> fetchRegistrations() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Event_Registration').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching registrations: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Registrations'),
      ),
      body: FutureBuilder(
        future: _registrationsFuture,
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<DocumentSnapshot> registrations = snapshot.data ?? [];
            if (registrations.isEmpty) {
              return Center(child: Text('No registrations found'));
            } else {
              return ListView.builder(
                itemCount: registrations.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> registrationData =
                      registrations[index].data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Name: ${registrationData['fullName']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${registrationData['email']}'),
                            Text('License Number: ${registrationData['licenseNumber']}'),
                            Text('Experience: ${registrationData['experience']}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(registrationData['vehicleImageUrl']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}