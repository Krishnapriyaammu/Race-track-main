import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/Racetrack/racetrackhome1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventAdd extends StatefulWidget {
  const EventAdd({super.key});

  @override
  State<EventAdd> createState() => _EventAddState();
}

class _EventAddState extends State<EventAdd> {
  int _generalPrice = 0; // State for general ticket price
  int _childPrice = 0; // State for child ticket price
  String _vipPrice = '';
  String _place = ''; // Declare place here

    File? _image;
      String imageUrl = ''; // Declare imageUrl here
 // Declare _image here
 // State for VIP ticket price

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveTicketDetails() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }
  SharedPreferences sp = await SharedPreferences.getInstance();
  var a = sp.getString('uid');

  await uploadImage();
  try {
    final CollectionReference tickets =
        FirebaseFirestore.instance.collection('racetrack_upload_event');
    int totalTickets = int.tryParse(_totalTicketsController.text) ?? 0;
    int totalVehicles = int.tryParse(_totalVehicle.text) ?? 0; // Parse total vehicles to int
    await tickets.add({
      'event_name': _eventNameController.text,
      'event_date': _eventDateController.text,
      'total_tickets': totalTickets,
      'general_price': _generalPrice,
      'image_url': imageUrl,
      'child_price': _childPrice,
      'vip_price': _vipPrice,
      'place': _place,
      'total_vehicles': totalVehicles, // Store total vehicles as int
      'rt_id': a,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Ticket details saved successfully.'),
      duration: Duration(seconds: 2),
    ));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RaceTrackViewEvents();
    }));
  } catch (e) {
    print('Error saving ticket details: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error saving ticket details: $e'),
      duration: Duration(seconds: 2),
    ));
  }
}
   String? _validateEventName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Event name is required';
    }
    return null;
  }

  String? _validateEventDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Event date is required';
    }
    return null;
  }

  String? _validateTotalTickets(String? value) {
    if (value == null || value.isEmpty) {
      return 'Total tickets is required';
    }
    int? totalTickets = int.tryParse(value);
    if (totalTickets == null || totalTickets <= 0) {
      return 'Invalid total tickets';
    }
    return null;
  }
   String? _validateTotalVehicles(String? value) {
    if (value == null || value.isEmpty) {
      return 'Total vehicles is required';
    }
    int? totalTickets = int.tryParse(value);
    if (totalTickets == null || totalTickets <= 0) {
      return 'Invalid total vehicles';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    int? price = int.tryParse(value);
    if (price == null || price <= 0) {
      return 'Invalid price';
    }
    return null;
  }
    DateTime? _selectedDate;


  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _totalTicketsController =
      TextEditingController();
        final TextEditingController _placeController = TextEditingController();
        final TextEditingController _totalVehicle =TextEditingController();

        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

 Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate ?? DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 10),
  );
  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
      // Format the picked date to only display the date part
      _eventDateController.text = '${picked.year}-${picked.month}-${picked.day}';
    });
  }
}

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDateController.dispose();
    _totalTicketsController.dispose();
    _totalVehicle.dispose();
     _placeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                _image != null
                    ? Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Icon(Icons.image, size: 100, color: Colors.grey),
                      ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _eventNameController,
                  validator: _validateEventName,
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _eventDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: _validateEventDate,
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                  SizedBox(height: 20),
                TextFormField(
                  controller: _placeController,
                  onChanged: (value) {
                    setState(() {
                      _place = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Place is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Place',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(height: 20),
                TextFormField(
                  controller: _totalTicketsController,
                  validator: _validateTotalTickets,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total tickets',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                  SizedBox(height: 20),
                TextFormField(
                  controller: _totalVehicle,
                  validator: _validateTotalVehicles,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total vehicles',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'General category',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _generalPrice = int.tryParse(value) ?? 0;
                              });
                            },
                            validator: _validatePrice,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Price (\$)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Child category',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _childPrice = int.tryParse(value) ?? 0;
                              });
                            },
                            validator: _validatePrice,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Price (\$)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'VIP category(extra amount)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _vipPrice = value;
                    });
                  },
                  validator: _validatePrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveTicketDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    try {
      if (_image != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('image/${_image!.path.split('/').last}');

        await storageReference.putFile(_image!);

        imageUrl = await storageReference.getDownloadURL();
        print('Image URL: $imageUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}