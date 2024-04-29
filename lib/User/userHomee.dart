// import 'package:flutter/material.dart';
// import 'package:loginrace/User/rentnavigation.dart';

// class UserTypeSelectionPage extends StatefulWidget {
//   const UserTypeSelectionPage({super.key});

//   @override
//   State<UserTypeSelectionPage> createState() => _UserTypeSelectionPageState();
// }

// class _UserTypeSelectionPageState extends State<UserTypeSelectionPage> {
//   @override
//  Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select User Type'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           _buildUserTypeCard(
//             context,
//             'Rental',
//             'images/download.jpg',
//             () {

//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return RentUserNavigation();
//                       }));
//             },
//           ),
//           SizedBox(height: 20.0),
//           _buildUserTypeCard(
//             context,
//             'Community',
//             'images/community.jpg',
//             () {
//               // Navigate to Community page
//             },
//           ),
//           SizedBox(height: 20.0),
//           _buildUserTypeCard(
//             context,
//             'Race Track',
//             'images/motor.jpg',
//             () {
//               // Navigate to Race Track page
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserTypeCard(
//     BuildContext context,
//     String title,
//     String imagePath,
//     Function onTap,
//   ) {
//     return InkWell(
//       onTap: () {
//         onTap();
//       },
//       child: Card(
//         elevation: 9.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 imagePath,
//                 width: 80.0,
//                 height: 80.0,
//               ),
//               SizedBox(height: 10.0),
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }