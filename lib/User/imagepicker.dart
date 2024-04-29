// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';


// class ImagePickerPage extends StatefulWidget {
//   @override
//   _ImagePickerPageState createState() => _ImagePickerPageState();
// }

// class _ImagePickerPageState extends State<ImagePickerPage> {
//    String? _image;

//   Future _pickImage() async {
//     ImagePicker picker = ImagePicker();
//     pickedFile = await picker.getImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = pickedFile.path as File?;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image != null
//                 ? Image.network(_image!, width: 300, height: 300)
//                 : Placeholder(
//                     fallbackHeight: 300,
//                     fallbackWidth: 300,
//                   ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text('Pick Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }