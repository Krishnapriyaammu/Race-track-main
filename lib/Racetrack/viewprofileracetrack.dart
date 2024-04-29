import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginrace/Common/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaceTrackViewProfile extends StatefulWidget {
  final String? userId;

  const RaceTrackViewProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<RaceTrackViewProfile> {
  late Future<DocumentSnapshot> userData;

  @override
  void initState() {
    super.initState();
    userData = getUserData();
  }

  Future<DocumentSnapshot> getUserData() async {
    return await FirebaseFirestore.instance
        .collection('race_track_register')
        .doc(widget.userId)
        .get();
        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Login(type: 'racetrack');
              }));
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(data['image_url'] ?? ''),
                    child: data['image_url'] == null
                        ? Icon(Icons.person, size: 70, color: Colors.white)
                        : null,
                  ),
                ),
                _buildProfileDetails(data),
              ],
            ),
          );
        },
      ),
    );
  }

 Widget _buildProfileDetails(Map<String, dynamic>? data) {
  if (data == null) {
    return Center(child: Text('No data available'));
  }

  return Padding(
    padding: const EdgeInsets.all(40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataTable(
          columns: [
            const DataColumn(
              label: SizedBox.shrink(),
            ),
            const DataColumn(
              label: SizedBox.shrink(),
            ),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Name')),
              DataCell(Text(data['name'] ?? '')),
            ]),
            DataRow(cells: [
              DataCell(Text('Email')),
              DataCell(Text(data['email'] ?? '')),
            ]),
            DataRow(cells: [
              DataCell(Text('Phone')),
              DataCell(Text(data['mobile_no'] ?? '')),
            ]),
            DataRow(cells: [
              DataCell(Text('Place')),
              DataCell(Text(data['place'] ?? '')),
            ]),
            // DataRow(cells: [
            //   DataCell(Text('Proof')),
            //   DataCell(Text(data['proof'] ?? '')),
            // ]),
          ],
        ),
        SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _editProfile(context, data),
            icon: Icon(Icons.edit),
            label: Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, Map<String, dynamic> data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    TextEditingController nameController = TextEditingController(text: data['name']);
    TextEditingController emailController = TextEditingController(text: data['email']);
    TextEditingController phoneController = TextEditingController(text: data['mobile_no']);
    TextEditingController placeController = TextEditingController(text: data['place']);
    // TextEditingController proofController = TextEditingController(text: data['proof']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                TextFormField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone')),
                TextFormField(controller: placeController, decoration: InputDecoration(labelText: 'Place')),
                // TextFormField(controller: proofController, decoration: InputDecoration(labelText: 'Proof')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update data in Firestore
                FirebaseFirestore.instance.collection('race_track_register').doc(widget.userId).update({
                  'name': nameController.text,
                  'email': emailController.text,
                  'mobile_no': phoneController.text,
                  'place': placeController.text,
                  // 'proof': proofController.text,
                }).then((_) {
                  Navigator.pop(context); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Profile updated successfully'),
                    duration: Duration(seconds: 2),
                  ));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to update profile: $error'),
                    duration: Duration(seconds: 2),
                  ));
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}