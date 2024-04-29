// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class MyBookingsStatusPage extends StatefulWidget {
//   @override
//   _MyBookingsStatusState createState() => _MyBookingsStatusState();
// }

// class _MyBookingsStatusState extends State<MyBookingsStatusPage> {
//   final TextEditingController feedbackController = TextEditingController();

//   void showFeedbackPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             "Give Feedback",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               RatingBar.builder(
//                 itemSize: 40,
//                 initialRating: 3,
//                 minRating: 1,
//                 direction: Axis.horizontal,
//                 allowHalfRating: true,
//                 itemCount: 5,
//                 itemBuilder: (context, _) => Icon(
//                   Icons.star,
//                   size: 20,
//                   color: Colors.deepPurpleAccent,
//                 ),
//                 onRatingUpdate: (rating) {
//                   print(rating);
//                 },
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: feedbackController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter your feedback',
//                 ),
//                 maxLines: 4,
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 String feedbackText = feedbackController.text;
//                 print("Feedback submitted: $feedbackText");
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurpleAccent,
//                 textStyle: TextStyle(color: Colors.white),
//               ),
//               child: Text("Send Feedback"),
//             ),
//             SizedBox(width: 10),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey,
//                 textStyle: TextStyle(color: Colors.white),
//               ),
//               child: Text("Cancel"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'View Status',
//           // style: TextStyle(color: Colors.deepPurpleAccent),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 120),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: AssetImage('images/cooo.jpg'),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'NAVANEETH MURALI',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text('Date: 5/9/2024'),
//               SizedBox(height: 8),
//               Text('Time: 2:00 pm'),
//               SizedBox(height: 8),
//               Text('Level: LEVEL 1'),
//               SizedBox(height: 8),
//               Text('Status: APPROVED'),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   showFeedbackPopup(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   // backgroundColor: Colors.deepPurpleAccent,
//                   textStyle: TextStyle(color: Colors.white),
//                 ),
//                 child: Text('Give Feedback'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
