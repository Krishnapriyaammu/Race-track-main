import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/Common/Login.dart';

class UserRgistration extends StatefulWidget {
  const UserRgistration({Key? key}) : super(key: key);

  @override
  State<UserRgistration> createState() => _UserRgistrationState();
}

class _UserRgistrationState extends State<UserRgistration> {
  var profileImage;
  XFile? pickedFile;
  File? image;
  var Name = TextEditingController();
  var Email = TextEditingController();
  var Place = TextEditingController();
  var password = TextEditingController();
  var confirmPass = TextEditingController();
  var Mobile = TextEditingController();
  final fkey = GlobalKey<FormState>();
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User Register')),
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
                          ? const Icon(Icons.camera_alt, size: 30)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (fkey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: Email.text,
                            password: password.text,
                          );

                          if (userCredential.user != null) {
                            await uploadImage();

                            await FirebaseFirestore.instance
                                .collection('user_register')
                                .doc(userCredential.user!.uid)
                                .set({
                              'name': Name.text,
                              'email': Email.text,
                              'place': Place.text,
                              'mobile no': Mobile.text,
                              'password': password.text,
                              'confirm_password': confirmPass.text,
                              'image_url': imageUrl,
                            });

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(type: 'user'),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Error creating user: $e');
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
            .child('image/${DateTime.now().millisecondsSinceEpoch}');

        await storageReference.putFile(profileImage!);

        imageUrl = await storageReference.getDownloadURL();

        print('Image URL: $imageUrl');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
