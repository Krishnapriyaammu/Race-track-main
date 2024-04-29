import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAddedChallenges extends StatefulWidget {
  const ViewAddedChallenges({super.key});

  @override
  State<ViewAddedChallenges> createState() => _ViewAddedChallengesState();
}

class _ViewAddedChallengesState extends State<ViewAddedChallenges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Added Challenges'),
      ),
      body: FutureBuilder(
        future: _getChallenges(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final challenge = documents[index].data() as Map<String, dynamic>;
                return _buildChallengeCard(challenge);
              },
            );
          }
        },
      ),
    );
  }

  Future<QuerySnapshot> _getChallenges() async {
    return FirebaseFirestore.instance.collection('challenges').get();
  }

  Widget _buildChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          challenge['title'] ?? 'Challenge Title',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(challenge['description'] ?? 'Challenge Description'),
        // trailing: Icon(Icons.chevron_right),
        onTap: () {
          // Add logic to navigate to a detailed view of the challenge
        },
      ),
    );
  }
}