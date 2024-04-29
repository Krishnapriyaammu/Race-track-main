import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventRegistrationPage extends StatefulWidget {
  String rt_id;
   EventRegistrationPage({super.key, required this. rt_id});

  @override
  State<EventRegistrationPage> createState() => _EventRegistrationPageState();
}

class _EventRegistrationPageState extends State<EventRegistrationPage> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  File? _vehicleImage;
  final ImagePicker _picker = ImagePicker();
  String? _selectedExperience;
  List<String> _experiences = ['3 years', '4 years', '5 years', '6 years', '7 years', '8 + years'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Event Registration'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: 
         Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Center(
      child: Text(
        'Event Registration Form',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    Row(
      children: [
        Text(
          '*',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        SizedBox(width: 5),
        Text(
          'Should participate in at least three or more events',
          style: TextStyle(fontSize: 14),
        ),
      ],
    ),
    SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _licenseNumberController,
                decoration: InputDecoration(labelText: 'License Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your license number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid license number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedExperience,
                items: _experiences.map((experience) {
                  return DropdownMenuItem<String>(
                    value: experience,
                    child: Text(experience),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExperience = value;
                  });
                },
                decoration: InputDecoration(
    labelText: 'Experience *', // Add asterisk to the label
    border: OutlineInputBorder(),
    suffixIcon: Text(
      '*', // Add asterisk as suffix icon
      style: TextStyle(color: Colors.red),
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select your experience';
    }
    return null;
                },
              ),
              SizedBox(height: 20),
              _vehicleImage != null
                  ? Image.file(
                      _vehicleImage!,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickVehicleImage,
                child: Text('Upload your vehicle'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRegistration,
                child: Text('Submit'),
              ),
            ],

          ),
        ),
      ),
    );
  }

  void _pickVehicleImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _vehicleImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      String fullName = _fullNameController.text;
      String email = _emailController.text;
      String phoneNumber = _phoneNumberController.text;
      String address = _addressController.text;
      String licenseNumber = _licenseNumberController.text;

      bool licenseExists =
      await _licenseNumberAlreadyExists(licenseNumber);

      if (licenseExists) {
        Fluttertoast.showToast(
          msg: "License number already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('uid');

      if (userId != null) {
        String vehicleImageUrl = await _uploadVehicleImage();

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference registrations =
        firestore.collection('Event_Registration');

        await registrations.add({
          'userId': userId,
          'event_id': widget.rt_id,
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'address': address,
          'licenseNumber': licenseNumber,
          'vehicleImageUrl': vehicleImageUrl,
          'experience': _selectedExperience,
        });

        print('Registration successful');
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot eventSnapshot = await transaction.get(
              FirebaseFirestore.instance
                  .collection('racetrack_upload_event')
                  .doc(widget.rt_id));
          int totalVehicles =
          (eventSnapshot.data() as Map<String, dynamic>)['total_vehicles'] ??
              0;
          int vehiclesBooked =
          1; // Assuming one vehicle is booked per registration, you can adjust this accordingly
          int updatedTotalVehicles = totalVehicles - vehiclesBooked;
          transaction.update(
              FirebaseFirestore.instance
                  .collection('racetrack_upload_event')
                  .doc(widget.rt_id),
              {'total_vehicles': updatedTotalVehicles});
        });
      } else {
        print('User ID not found in SharedPreferences.');
      }
    }
  }

  Future<bool> _licenseNumberAlreadyExists(String licenseNumber) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Event_Registration')
        .where('licenseNumber', isEqualTo: licenseNumber)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> _uploadVehicleImage() async {
    try {
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('vehicle_images/$fileName.jpg');
      await storageReference.putFile(_vehicleImage!);
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading vehicle image: $e');
      throw e;
    }
  }
}