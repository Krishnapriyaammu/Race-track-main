import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginrace/User/viewprofile.dart';

class UserEditProfile extends StatefulWidget {
  const UserEditProfile({Key? key}) : super(key: key);

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  var profileImage;
  XFile? pickedFile;
  File? image;
  var Name = TextEditingController();
  var Email = TextEditingController();
  var Place = TextEditingController();
    var Mobile = TextEditingController();
 
  final fkey = GlobalKey<FormState>();
  String imageUrl='';

  // List of years of experience options
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Edit')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(key: fkey,
                child: Container(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            ImagePicker picker = ImagePicker();
                            pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);

                            setState(() {
                              if (pickedFile != null) {
                                profileImage = File(pickedFile!.path);
                              }
                            });
                          },
                          child: ClipOval(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: profileImage != null
                                  ? FileImage(profileImage)
                                  : null,
                              child: profileImage == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Name'),
                            ),
                          ],
                        ),
                        TextFormField(controller: Name,
                         validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter Name';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 224, 206, 221),
                            filled: true,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Email'),
                            ),
                          ],
                        ),
                        TextFormField(controller: Email,
                         validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter email';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 224, 206, 221),
                            filled: true,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Place'),
                            ),
                          ],
                        ),
                        TextFormField(controller: Name,
                         validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter place';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 224, 206, 221),
                            filled: true,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Mobile Number'),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: Mobile,
                           validator: (value) {
                            if (value!.isEmpty) {
                              return 'field is empty';
                            }
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 224, 206, 221),
                              filled: true,
                              border: UnderlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  borderSide: BorderSide.none)),
                        ),
                       
                       
                        // ... (remaining code)
                
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          
                          onPressed: () async {
                            await uploadImage();
                            await FirebaseFirestore.instance
                                .collection('usereditprofile')
                                .add({
                              'name': Name.text,
                              'email': Email.text,
                               'place':Place.text,
                              'mobile no': Mobile.text,
                              'image_url': imageUrl,

                             
                            });
                            print(Name.text);
                              print(Email.text);
                             
                              print(Mobile.text);
                            print(Place.text);
                               if (fkey.currentState!.validate()) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Viewprofile(userId: 'userId',);
                                
                            }));
                               }
                          },
                          child: Text('Done'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
Future<void> uploadImage() async {
    try {
      if (profileImage != null) {
        
        Reference storageReference =
            FirebaseStorage.instance
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