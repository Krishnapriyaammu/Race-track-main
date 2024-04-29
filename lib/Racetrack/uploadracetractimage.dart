// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class UploadRaceTrackImage extends StatefulWidget {
//   const UploadRaceTrackImage({super.key});

//   @override
//   State<UploadRaceTrackImage> createState() => _UploadRaceTrackImageState();
// }

// class _UploadRaceTrackImageState extends State<UploadRaceTrackImage> {
//     var DescriptionEdit = TextEditingController();
//   final fkey = GlobalKey<FormState>();
//   var profileImage;
//   XFile? pickedFile;

//   File? _selectedImage;
//   String imageUrl = '';


//   final picker = ImagePicker();

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _selectedImage = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//  appBar: AppBar(
//         title: Text('Image Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             InkWell(
//               onTap: _pickImage,
//               child: Form(
//                 key: fkey,
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(15),
//                     image: _selectedImage != null
//                         ? DecorationImage(
//                             image: FileImage(_selectedImage!),
//                             fit: BoxFit.cover,
//                           )
//                         : null,
//                   ),
//                   child: _selectedImage == null
//                       ? Icon(
//                           Icons.camera_alt,
//                           size: 40,
//                           color: Colors.grey[600],
//                         )
//                       : null,
//                 ),
//               ),
//             ),
//              SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: TextFormField(
//                   maxLines: 5,
//                   controller: DescriptionEdit,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Field is empty';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Describe here',
//                     fillColor: Color.fromARGB(255, 180, 206, 251),
//                     filled: true,
//                     border: UnderlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: ()async {
//                   await uploadImage();
//                   await FirebaseFirestore.instance
//                       .collection("racetrack_upload_racetrack")
//                       .add({
//                                    'description': DescriptionEdit.text,

//                                     'image_url': imageUrl,
//                       });
//              if (fkey.currentState!.validate()) {
//                     print(DescriptionEdit.text);
//      Navigator.push(context, MaterialPageRoute(builder: (context) {
//                             return Race;
//                   },));
//              }
//               },
             
//               child: Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),





//     );
//   }
// Future<void> uploadImage() async {
//     try {
//       if (_selectedImage != null) {
//         Reference storageReference = FirebaseStorage.instance
//             .ref()
//             .child('image/${_selectedImage!.path.split('/').last}');

//         await storageReference.putFile(_selectedImage!);

//         // Get the download URL
//         imageUrl = await storageReference.getDownloadURL();

//         // Now you can use imageUrl as needed (e.g., save it to Firestore)
//         print('Image URL: $imageUrl');
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
// }
