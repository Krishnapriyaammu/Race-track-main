import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/Common/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class raceRegistration extends StatefulWidget {
  const raceRegistration({super.key});

  @override
  State<raceRegistration> createState() => _raceRegistrationState();
}

class _raceRegistrationState extends State<raceRegistration> {
   var profileImage;
  XFile? pickedFile;
  File? image;
  var Name = TextEditingController();
  var Email = TextEditingController();
  var Place = TextEditingController();
  var proof = TextEditingController();
  var password = TextEditingController();
  var confirmPass = TextEditingController();
  var Mobile = TextEditingController();
  final fkey = GlobalKey<FormState>();
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Race track Register')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: fkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () async {
                      ImagePicker picker = ImagePicker();
                      pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);

                      setState(() {
                        if (pickedFile != null) {
                          profileImage = File(pickedFile!.path);
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          profileImage != null ? FileImage(profileImage) : null,
                      child: profileImage == null
                          ? Icon(Icons.camera_alt, size: 30)
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: Name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: Email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: Place,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Place';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Place',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: Mobile,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Mobile Number';
                      }
                      if (value.length != 10) {
                        return 'Mobile Number must be 10 digits';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Invalid Mobile Number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPass,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Password';
                      }
                      if (value != password.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (fkey.currentState!.validate()) {
                        // SharedPreferences sp =
                        //     await SharedPreferences.getInstance();
                        // var a = sp.getString('uid');
                        await uploadImage();

                        var existingUser = await FirebaseFirestore.instance
                            .collection('race_track_register')
                            .where('email', isEqualTo: Email.text)
                            .get();

                        if (existingUser.docs.isNotEmpty) {
                          // User already exists with the same email
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'User with this email already exists.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          await FirebaseFirestore.instance
                              .collection('race_track_register')
                              .add({
                            'name': Name.text,
                            'email': Email.text,
                            'place': Place.text,
                            // 'proof': proof.text,
                            'mobile_no': Mobile.text,
                            'password': password.text,
                            'conform password': confirmPass.text,
                            'image_url': imageUrl,
                            'status': 0,
                          });
                          print(Name.text);
                          print(Email.text);
                          print(Mobile.text);
                          print(password.text);
                          print(confirmPass.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(type: 'race track'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    try {
      if (profileImage != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('image/${pickedFile!.name}');

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