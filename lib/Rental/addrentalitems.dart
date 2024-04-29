import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentalServicePage extends StatefulWidget {
  @override
  _RentalServicePageState createState() => _RentalServicePageState();
}



class _RentalServicePageState extends State<RentalServicePage> {

    Future<List<DocumentSnapshot>> getData() async {
    try {
       SharedPreferences sp = await SharedPreferences.getInstance();
                     var a = sp.getString('uid');

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('rental_add_service').where('rent_id',isEqualTo: a)
          .get();
      print('Fetched ${snapshot.docs.length} documents');
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to handle it in the FutureBuilder
    }
  }
  TextEditingController _nameController = TextEditingController();
  TextEditingController _serviceController = TextEditingController();
  String imageUrl='';
  var profileImage;
  XFile? pickedFile;
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rental Service Products'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final document = snapshot.data![index];
                final data = document.data() as Map<String, dynamic>;
                final imageUrl = data['image_url'];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 200, 225, 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: imageUrl != null
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Icon(Icons.image),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          data['Renter Name'] ?? 'Name not available',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          data['Rental Service'] ?? 'Service not available',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, document);
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editProduct(context, document);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDetailsDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _editProduct(BuildContext context, DocumentSnapshot document) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProductPage(document: document, onDataEdited: refreshData)),
    );
    if (result != null && result) {
      setState(() {
        // Refresh the data
      });
    }
  }

  void refreshData() {
    setState(() {
      // Refresh the data
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProduct(document);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(DocumentSnapshot document) async {
    try {
      await document.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product deleted successfully.'),
        ),
      );
      setState(() {
        // Refresh the data
      });
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product: $e'),
        ),
      );
    }
  }

  void _showAddDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Rental Service'),
          content: _buildAddContainer(context),
        );
      },
    );
  }

  Widget _buildAddContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                ImagePicker picker = ImagePicker();
                pickedFile = await picker.pickImage(source: ImageSource.gallery);

                setState(() {
                  if (pickedFile != null) {
                    profileImage = File(pickedFile!.path);
                  }
                });
              },
              child: ClipOval(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null ? FileImage(profileImage) : null,
                  child: profileImage == null ? Icon(Icons.camera_alt, size: 30) : null,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Renter Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(
                labelText: 'Rental Service',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                var a = sp.getString('uid');

                await uploadImage();

                await FirebaseFirestore.instance.collection('rental_add_service').add({
                  'Renter Name': _nameController.text,
                  'Rental Service': _serviceController.text,
                  'image_url': imageUrl,
                  'rent_id': a
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RentalServicePage();
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
      if (profileImage != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child('image/${pickedFile!.name}');

        await storageReference.putFile(profileImage!);

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

class EditProductPage extends StatefulWidget {
  final DocumentSnapshot document;
  final VoidCallback onDataEdited;

  EditProductPage({required this.document, required this.onDataEdited});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _serviceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = widget.document.data() as Map<String, dynamic>;
    _nameController.text = data['Renter Name'];
    _serviceController.text = data['Rental Service'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Renter Name'),
            ),
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Rental Service'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await widget.document.reference.update({
                    'Renter Name': _nameController.text,
                    'Rental Service': _serviceController.text,
                  });
                  widget.onDataEdited(); // Trigger data refresh in RentalServicePage
                  Navigator.pop(context, true); // Pass true to indicate changes saved
                } catch (e) {
                  print('Error updating data: $e');
                  // Handle error updating data
                  // You can show a snackbar or dialog to inform the user about the error
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serviceController.dispose();
    super.dispose();
  }
}