import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddChallenge extends StatefulWidget {
  const AddChallenge({super.key});

  @override
  State<AddChallenge> createState() => _AddChallengeState();
}

class _AddChallengeState extends State<AddChallenge> {
   final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Challenge Type'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add the challenge type to Firebase Firestore
                _addChallengeType();
              },
              child: Text('Add Challenge '),
            ),
          ],
        ),
      ),
    );
  }

  void _addChallengeType() {
    // Retrieve the values from the text fields
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

 
    FirebaseFirestore.instance.collection('challenges').add({
      'title': title,
      'description': description,
    }).then((value) {
      // Challenge type added successfully
      print('Challenge type added successfully!');
      
      // Clear the text fields after adding the challenge type
      _titleController.clear();
      _descriptionController.clear();

      // Navigate back to the previous page
      Navigator.pop(context);
    }).catchError((error) {
      // Error occurred while adding the challenge type
      print('Error adding challenge type: $error');
      
    });
  }
}