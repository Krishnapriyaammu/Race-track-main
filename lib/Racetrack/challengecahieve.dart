import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/Racetrack/addchallenge.dart';
import 'package:loginrace/Racetrack/viewaddedchallenges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
   List<Map<String, dynamic>> completedChallenges = [];

  @override
  void initState() {
    super.initState();
    _fetchCompletedChallenges();
  }

  Future<void> _fetchCompletedChallenges() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('completed_challenges')
          .get();

      List<Map<String, dynamic>> tempCompletedChallenges = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> challengeData = doc.data() as Map<String, dynamic>;
        String userId = challengeData['userId'];
        // Fetch user details from user_register collection
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user_register')
            .doc(userId)
            .get();
        String userName =
            (userSnapshot.data() as Map<String, dynamic>)['name'] ?? 'Unknown User';
        String profileImageUrl = (userSnapshot.data() as Map<String, dynamic>)['image_url'] ??
            ''; // Assuming profile image URL is stored in 'image_url' field

        challengeData['userName'] = userName;
        challengeData['profileImageUrl'] = profileImageUrl; // Add profileImageUrl to challenge data
        tempCompletedChallenges.add(challengeData);
      }

      setState(() {
        completedChallenges = tempCompletedChallenges;
      });
    } catch (e) {
      print('Error fetching completed challenges: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Challenges'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: completedChallenges.length,
        itemBuilder: (context, index) {
          final challenge = completedChallenges[index];
          return GestureDetector(
            onTap: () {
              // Handle tap action
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: challenge['profileImageUrl'] != null
                        ? NetworkImage(challenge['profileImageUrl'] as String)
                        : AssetImage('assets/default_profile_image.jpg') as ImageProvider,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    challenge['title'].toString() ?? 'Challenge Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Completed by: ${challenge['userName']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddChallenge()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewAddedChallenges()),
            );
          },
          child: Text('View Challenges'),
        ),
      ],
    );
  }
}