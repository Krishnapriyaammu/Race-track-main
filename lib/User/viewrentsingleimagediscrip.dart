import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginrace/User/userfirstpage.dart';
import 'package:loginrace/User/viewstatuspage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewSingleItem extends StatefulWidget {
 final String rent_id;
  final String imageUrl;
  final String price;  
  
  UserViewSingleItem({Key? key, required this.rent_id, required this. imageUrl, required this. price}) : super(key: key);

  @override
  State<UserViewSingleItem> createState() => _UserViewSingleItemState();
}

class _UserViewSingleItemState extends State<UserViewSingleItem> {
   late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _placeController;
  late TextEditingController _dueDateController;
  late TextEditingController _addressController;
  int _selectedQuantity = 1;
  Map<String, dynamic> _rentalImageData = {};
  String? documentId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mobileController = TextEditingController();
    _placeController = TextEditingController();
    _dueDateController = TextEditingController();
    _addressController = TextEditingController();
    _fetchRentalImageData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _placeController.dispose();
    _dueDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchRentalImageData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rental_upload_image')
          .doc(widget.rent_id)
          .get();
      if (snapshot.exists) {
        setState(() {
          _rentalImageData = snapshot.data() as Map<String, dynamic>;
        });
      } else {
        print('Rental image data not found for ID: ${widget.rent_id}');
      }

      if (_rentalImageData.isNotEmpty) {
        print('Rental image data: $_rentalImageData');
        print('Rental image price: ${_rentalImageData['price']}');
      } else {
        print('_rentalImageData is empty');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _updateTotalPrice(int quantity) {
    setState(() {
      _selectedQuantity = quantity;
    });
  }
String _calculateTotalPrice() {
  double price = double.tryParse(widget.price) ?? 0.0; // Convert price to double
  double totalPrice = price * _selectedQuantity;
  return totalPrice.toStringAsFixed(2); // Convert total price back to string with 2 decimal places
}
  Future<void> _bookItem() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var userId = sp.getString('uid');
    var currentDate = DateTime.now();

    if (_rentalImageData.isEmpty) {
      print('_rentalImageData is empty');
      return;
    }

    String totalPrice = _calculateTotalPrice();

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('user_rent_booking')
        .add({
      'name': _nameController.text,
      'place': _placeController.text,
      'mobile no': _mobileController.text,
      'due_date': _dueDateController.text,
      'address': _addressController.text,
      'quantity': _selectedQuantity,
      'userid': userId,
      'rent_id': widget.rent_id,
      'status': 0,
      'booking_date': currentDate,
      'total_price': totalPrice,
    });

    setState(() {
      documentId = docRef.id;
    });

    await FirebaseFirestore.instance
        .collection('rental_upload_image')
        .doc(widget.rent_id)
        .update({
      'total_count': _rentalImageData['total_count'] - _selectedQuantity,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display rental image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Dropdown to select quantity
        Row(
  children: [
    Text('Select Quantity: '),
    DropdownButton<int>(
      value: _selectedQuantity,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedQuantity = value;
          });
          _updateTotalPrice(value); // Update total price
        }
      },
      items: List.generate(
        3,
        (index) => DropdownMenuItem<int>(
          value: index + 1,
          child: Text((index + 1).toString()),
        ),
      )..add(
        DropdownMenuItem<int>(
          value: 4,
          child: Text('More'),
                      ),
                    ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Display description
            Text(
              _rentalImageData['description'] ?? 'Description not available',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // Display price
           Text(
  'Price: \$${_calculateTotalPrice()}',
  style: TextStyle(fontSize: 16.0),
),
            SizedBox(height: 8.0),
            Text(
              'Total Count: ${_rentalImageData['total_count'] ?? 'Not available'}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            // Button to rent item
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Rent Item'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter your details to rent the item:'),
                            SizedBox(height: 10.0),
                            TextFormField(
                              controller: _nameController,
                              // readOnly: true,
                              decoration:
                                  InputDecoration(labelText: 'Full Name'),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _mobileController,
                              decoration: InputDecoration(
                                  labelText: 'Contact Number'),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _placeController,
                              // readOnly: true,
                              decoration: InputDecoration(labelText: 'Place'),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _addressController,
                              decoration:
                                  InputDecoration(labelText: 'Address'),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _dueDateController,
                              // readOnly: true,
                              decoration:
                                  InputDecoration(labelText: 'Due date'),
                              onTap: () async {
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );

                                if (selectedDate != null) {
                                  setState(() {
                                    _dueDateController.text =
                                        selectedDate.toString().split(' ')[0];
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 8.0),
                            Text(
                                'Selected Quantity: $_selectedQuantity'),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: _bookItem,
                          child: Text('Submit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Rent'),
            ),
            // Button to view status
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewStatusPage(
                      rent_id: widget.rent_id,
                      documentId: documentId ?? '',
                      price: _calculateTotalPrice(),
                    ),
                  ),
                );
              },
              child: Text('View Status'),
            ),
          ],
        ),
      ),
    );
  }
}