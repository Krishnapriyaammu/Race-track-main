// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:loginrace/Racetrack/navigationracetrack.dart';
// import 'package:loginrace/Racetrack/racetrackhome2.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TrackAmount extends StatefulWidget {
//   const TrackAmount({super.key});

//   @override
//   State<TrackAmount> createState() => _TrackAmountState();
// }

// class _TrackAmountState extends State<TrackAmount> {
//    var _eventController = TextEditingController();
//   var _level1Controller = TextEditingController();
//   var _level2Controller = TextEditingController();
//   final fkey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Amount'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: fkey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: _eventController,
//                 decoration: InputDecoration(
//                   labelText: ' Upcoming Event',
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _level1Controller,
//                 decoration: InputDecoration(
//                   labelText: 'Amount of Level 1',
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: _level2Controller,
//                 decoration: InputDecoration(
//                   labelText: 'Amount of Level 2',
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {

//                    SharedPreferences sp = await SharedPreferences.getInstance();
//                      var a = sp.getString('uid');
//                   await FirebaseFirestore.instance
//                       .collection("racetrack_upcoming_event")
//                       .add({
//                     'event': _eventController.text,
//                     'level1': _level1Controller.text,
//                     'level2': _level2Controller.text,
//                     'uid':a,

//                   });

//                   if (fkey.currentState!.validate()) {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) {
//                       return RaceTrackNavigation();
//                     }));
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Data added successfully'),
//                       ),
//                     );
//                   }
//                 },
//                 child: Center(
//                   child: Text('Add'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }