import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/Community/addautoshows.dart';
import 'package:loginrace/Community/addimages.dart';
import 'package:loginrace/Community/joincommunity1.dart';
import 'package:loginrace/Community/booking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewPage extends StatefulWidget {
        const ProfileViewPage({super.key, });


  @override
  _ProfileViewPageState createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
 final ImagePicker _picker = ImagePicker();
  late File _image;
  late List<String> _imageUrls = []; // Initialize _imageUrls as an empty list
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  late String? sp=null;
  late String? img= null;
  late String? id;

  Future<void> _loadImages() async {
    SharedPreferences spr = await SharedPreferences.getInstance();
    setState(() {
      sp = spr.getString('name');
      img = spr.getString('image_url');
      id = spr.getString('uid');
    });
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_upload_image')
          .where('community_id', isEqualTo: id)
          .get();

      setState(() {
        _imageUrls =
            snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
      });
    } catch (error) {
      print('Error loading images: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Upload_pic_describe(imageFile: _image),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _getImage,
          ),
        ],
        title: Text(
          'HOME',
          style: TextStyle(color: Colors.deepPurple),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: img != null ? NetworkImage(img!) : null,
              radius: 70,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              sp ?? '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAutoshows(community_id: id ?? '')),
                    );
                  },
                  child: Text('AUTO SHOWS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 229, 225, 235),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.6),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewAllMessage(community_id: id ?? '')),
                    );
                  },
                  child: Text('Members'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(221, 226, 219, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.6),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Adjust as needed
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: _imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          _imageUrls[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}