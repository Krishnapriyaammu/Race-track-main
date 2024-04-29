import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewChallenges extends StatefulWidget {
  const UserViewChallenges({super.key});

  @override
  State<UserViewChallenges> createState() => _UserViewChallengesState();
}

class _UserViewChallengesState extends State<UserViewChallenges> {
     late List<Map<String, dynamic>> challenges;
  late List<Map<String, dynamic>> completedChallenges;
  late String userId; // Added userId variable

  @override
  void initState() {
    super.initState();
    // Initialize lists
    challenges = [];
    completedChallenges = [];
    // Fetch challenges from Firestore
    _fetchChallenges();
    // Fetch completed challenges from Firestore
    _fetchCompletedChallenges();
    // Retrieve user ID from SharedPreferences
    _retrieveUserId();
  }

  // Retrieve user ID from SharedPreferences
  Future<void> _retrieveUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString('uid') ?? ''; // Default value if user ID is not available
  }

  // Fetch challenges from Firestore
  Future<void> _fetchChallenges() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('challenges').get();
      setState(() {
        challenges =
            querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching challenges: $e');
    }
  }

  // Fetch completed challenges from Firestore
  Future<void> _fetchCompletedChallenges() async {
  try {
    FirebaseFirestore.instance
        .collection('completed_challenges')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      setState(() {
        completedChallenges =
            querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    });
  } catch (e) {
    print('Error fetching completed challenges: $e');
  }
}

  // Mark challenge as completed
  void _markChallengeCompleted(Map<String, dynamic> challenge) {
    // Add the completed challenge to Firestore with user ID
    Map<String, dynamic> completedChallengeWithUserId = {
      ...challenge,
      'userId': userId,
    };
    FirebaseFirestore.instance.collection('completed_challenges').add(completedChallengeWithUserId);
    // Update UI
    setState(() {
      completedChallenges.add(completedChallengeWithUserId);
    });
  }

  // Check if a challenge is completed
  bool _isChallengeCompleted(String title) {
    return completedChallenges.any((completedChallenge) => completedChallenge['title'] == title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges & Achievements'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your Challenges',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                final title = challenge['title'] as String;
                final description = challenge['description'] as String;
                return Card(
                  color: _isChallengeCompleted(title) ? Colors.green[100] : Colors.white,
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(description),
                    trailing: IconButton(
                      icon: _isChallengeCompleted(title)
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.radio_button_unchecked),
                      onPressed: () {
                        if (!_isChallengeCompleted(title)) {
                          _markChallengeCompleted(challenge);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Your Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: completedChallenges.length,
              itemBuilder: (context, index) {
                final completedChallenge = completedChallenges[index];
                final title = completedChallenge['title'] as String;
                final description = completedChallenge['description'] as String;
                return Card(
                  color: Colors.yellow[100],
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(description),
                    trailing: Icon(Icons.star, color: Colors.yellow[700]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}