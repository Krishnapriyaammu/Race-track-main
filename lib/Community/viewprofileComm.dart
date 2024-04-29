import 'package:flutter/material.dart';
import 'package:loginrace/Community/commeditprofil.dart';

class CommViewProfile extends StatefulWidget {
  const CommViewProfile({super.key});

  @override
  State<CommViewProfile> createState() => _CommViewProfileState();
}

class _CommViewProfileState extends State<CommViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(
  
  
          title: Text('View Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_note_outlined),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return Commueditprofile();
                  },));
              },
            ),
          ],
        ),
        body: 
              Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 330),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('images/imaaaa.jpg'), 
            ),
            SizedBox(height: 16),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '123-456-7890',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'City, Country',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Proof: XYZ123',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),








     ),





    );
  }
}