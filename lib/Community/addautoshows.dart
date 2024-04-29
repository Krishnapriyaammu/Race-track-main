import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginrace/Community/addimagesautoshow.dart';
import 'package:loginrace/Community/searchautoshow.dart';
import 'package:loginrace/Community/viewautoshows.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAutoshows extends StatefulWidget {
  String community_id;
   AddAutoshows({super.key, required this.community_id});

  @override
  State<AddAutoshows> createState() => _AddAutoshowsState();
}

class _AddAutoshowsState extends State<AddAutoshows> {
 TextEditingController _priceController = TextEditingController();
  String? _selectedCategory;
  Map<String, String> _categoryPrices = {
    'Vintage Car': '',
    'Motor Bikes': '',
    'Sports Car': '',
    'Luxury Car': '',
  };
  List<File>? _uploadedImages;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categoryPrices.keys.first;
    // Call method to fetch price for initial category
    _fetchPriceForCategory(_selectedCategory!);
  }

  // Method to fetch price for a category
  Future<void> _fetchPriceForCategory(String category) async {
    // Query Firestore to get price for the category
    final querySnapshot = await FirebaseFirestore.instance
        .collection('category_price')
        .where('category', isEqualTo: category)
        .where('community_id', isEqualTo: widget.community_id)
        .get();

    // Check if any documents are found
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document and extract price
      final price = querySnapshot.docs.first.get('price') as String?;
      // Update the price in the category prices map only for the selected category
      setState(() {
        _categoryPrices[category] = price ?? '';
        // Update the price controller text field
        _priceController.text = price ?? '';
      });
    } else {
      // If no document is found, set the price for the category to empty string
      setState(() {
        _categoryPrices[category] = '';
        _priceController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Auto Show',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Vehicle Category:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categoryPrices.keys.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    // Call method to fetch price for the selected category
                    _fetchPriceForCategory(value!);
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select Category',
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Price:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      onChanged: (value) {
                        // Update the price in the category prices map as the user types
                        // Do not update the map here to prevent incorrect prices
                      },
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Update the price in the category prices map when the button is pressed
                        _categoryPrices[_selectedCategory!] = _priceController.text;
                      });
                      _priceController.clear();
                    },
                    child: Text('Update Price'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: () async {
                  final List<File>? images = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddImageAutoshow(
                        category: _selectedCategory!,
                        price: _categoryPrices[_selectedCategory] ?? '', // Pass the price
                      ),
                    ),
                  );
                  if (images != null) {
                    setState(() {
                      _uploadedImages = images;
                    });
                  }
                },
                icon: Icon(Icons.add_photo_alternate),
                label: Text('Add Images'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _uploadedImages != null && _uploadedImages!.isNotEmpty
                  ? GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: _uploadedImages!.map((image) {
                  return GridTile(
                    child: Image.file(image, fit: BoxFit.cover),
                  );
                }).toList(),
              )
                  : _selectedCategory != null
                  ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('community_add_autoshows')
                    .where('category', isEqualTo: _selectedCategory)
                    .where('community_id', isEqualTo: widget.community_id) // Filter by community ID
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<DocumentSnapshot<Map<String, dynamic>>>
                  documents = snapshot.data!.docs;
                  return GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> data =
                      documents[index].data()!;
                      final imageUrl =
                      data['image_url'] as String?;
                      return GridTile(
                        child: Column(
                          children: [
                            Expanded(
                              child: imageUrl != null
                                  ? Image.network(imageUrl,
                                  fit: BoxFit.cover)
                                  : Container(),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
                  : Container(),
              SizedBox(height: 250.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Save the category and price to Firebase
                      await FirebaseFirestore.instance.collection('category_price').add({
                        'category': _selectedCategory,
                        'price': _categoryPrices[_selectedCategory],
                        'community_id': widget.community_id,
                      });

                      Fluttertoast.showToast(
                        msg: 'Auto Show saved successfully',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                      );
                    },
                    child: Text(
                      'Save Auto Show',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchAutoshow(community_id: widget.community_id),
                        ),
                      );
                    },
                    child: Text(
                      'View',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}