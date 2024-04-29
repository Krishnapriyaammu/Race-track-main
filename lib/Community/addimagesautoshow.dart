import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddImageAutoshow extends StatefulWidget {
    final String category;
  final String price;
   AddImageAutoshow({super.key,required this.category, required this. price, });

  @override
  State<AddImageAutoshow> createState() => _AddImageAutoshowState();
}

class _AddImageAutoshowState extends State<AddImageAutoshow> {
    List<File> _selectedImages = [];

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Images'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => _getImage(ImageSource.gallery),
            child: Text('Select Image from Gallery'),
          ),
          SizedBox(height: 10),
          Text(
            'Category: ${widget.category}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Price: ${widget.price}',
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return GridTile(
                  child: Image.file(
                    _selectedImages[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              var uid = sp.getString('uid');

              for (var imageFile in _selectedImages) {
                Reference storageReference = FirebaseStorage.instance
                    .ref()
                    .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

                await storageReference.putFile(imageFile);

                String imageUrl = await storageReference.getDownloadURL();

                await FirebaseFirestore.instance.collection("community_add_autoshows").add({
                  'image_url': imageUrl,
                  'community_id': uid,
                  'category': widget.category,
                  'price': widget.price,
                });
              }

              Navigator.of(context).pop();
            },
            child: Text('Upload'),
          ),
        ],
      ),
    );
  }
}