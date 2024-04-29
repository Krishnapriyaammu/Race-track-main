import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserJoinCommunity extends StatefulWidget {
  const UserJoinCommunity({super.key});

  @override
  State<UserJoinCommunity> createState() => _UserJoinCommunityState();
}

class _UserJoinCommunityState extends State<UserJoinCommunity> {
    final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  String _selectedVehicleType = '';
  Uint8List? _vehicleImageBytes;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>(); // Add form key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Membership Request Form',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Phone Number';
                          }
                          if (value.length != 10) {
                            return 'Phone Number must be 10 digits';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _licenseNumberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter License Number';
                          }
                          if (_licenseNumberController.text == value) {
                            return 'License Number cannot be the same';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'License Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedVehicleType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedVehicleType = newValue!;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text('Select Vehicle Type'),
                          ),
                          DropdownMenuItem(
                            value: 'Car',
                            child: Text('Car'),
                          ),
                          DropdownMenuItem(
                            value: 'Motorcycle',
                            child: Text('Motorcycle'),
                          ),
                          DropdownMenuItem(
                            value: 'Truck',
                            child: Text('Truck'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Vehicle Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickVehicleImage,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.file_upload),
                              SizedBox(width: 10),
                              Text('Upload Vehicle Image'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _vehicleImageBytes != null
                          ? Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.memory(
                                _vehicleImageBytes!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _joinCommunity,
                        child: Text('Join Community'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _pickVehicleImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _vehicleImageBytes = bytes;
      });
    }
  }

  Future<void> _joinCommunity() async {
    if (_formKey.currentState!.validate()) {
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneNumberController.text.isEmpty ||
          _licenseNumberController.text.isEmpty ||
          _selectedVehicleType.isEmpty ||
          _vehicleImageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields'),
          ),
        );
        return;
      }
      // Your joining community logic here
    }
  }
}
