import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/Rental/viewrentproducts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentUploadImage extends StatefulWidget {
  const RentUploadImage({super.key});

  @override
  State<RentUploadImage> createState() => _RentUploadImageState();
}

class _RentUploadImageState extends State<RentUploadImage> {
   var DescriptionEdit = TextEditingController();
  var PriceEdit = TextEditingController();
  var CountEdit = TextEditingController();
  String? documentId; // Variable to store the document ID

  String imageUrl = '';
  File? _selectedImage;
  final picker = ImagePicker();
  String? selectedCategory;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Events'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                hint: Text('Select Category'),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: ['Bikes', 'Cars', 'Riding Gears']
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: _selectedImage == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.grey[600],
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                maxLines: 5,
                controller: DescriptionEdit,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Describe here',
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: PriceEdit,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: CountEdit,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Count',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                var a = sp.getString('uid');

                // Upload image
                await uploadImage();
                int totalCount = int.tryParse(CountEdit.text) ?? 0;

                // Add data to Firestore
                DocumentReference docRef = await FirebaseFirestore.instance.collection('rental_upload_image').add({
                  'category': selectedCategory,
                  'description': DescriptionEdit.text,
                  'image_url': imageUrl,
                  'price': PriceEdit.text, // Add price field
                  'total_count': totalCount, // Add total count field
                  'rent_id': a,
                });
                documentId = docRef.id;

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductViewPage();
                }));
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    try {
      if (_selectedImage != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child('image/${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageReference.putFile(_selectedImage!);

        // Get the download URL
        imageUrl = await storageReference.getDownloadURL();

        // Now you can use imageUrl as needed (e.g., save it to Firestore)
        print('Image URL: $imageUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}