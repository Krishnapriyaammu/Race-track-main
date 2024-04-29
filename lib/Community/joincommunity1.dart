
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ViewAllMessage extends StatefulWidget {
  String community_id;
   ViewAllMessage({super.key, required this. community_id});

  @override
  State<ViewAllMessage> createState() => _ViewAllMessageState();
}

class _ViewAllMessageState extends State<ViewAllMessage> {
  Future<List<DocumentSnapshot>> getBookedUsers() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Join_Community')
          .where('community_id', isEqualTo: widget.community_id)
          .get();
      return snapshot.docs;
    } catch (e) {
      print('Error fetching booked users: $e');
      throw e;
    }
  }

  Future<String> getUserProfileImage(String email) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_register')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data() as Map<String, dynamic>;
        return userData['image_url'] ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print('Error fetching user profile image: $e');
      return '';
    }
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Community'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: getBookedUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<DocumentSnapshot> bookedUsers = snapshot.data ?? [];
            return ListView.builder(
              itemCount: bookedUsers.length,
              itemBuilder: (context, index) {
                final userData = bookedUsers[index].data() as Map<String, dynamic>;

                return FutureBuilder<String>(
                  future: getUserProfileImage(userData['email']),
                  builder: (context, imageSnapshot) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(imageSnapshot.data ?? ''),
                        ),
                        title: Text(
                          userData['name'] ?? 'Name not available',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              'Email: ${userData['email'] ?? 'Email not available'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Phone: ${userData['phone'] ?? 'Phone number not available'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'License Number: ${userData['licenseNumber'] ?? 'License number not available'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Image.network(
                              userData['imageUrl'] ?? '',
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Text('Vehicle image not available');
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}