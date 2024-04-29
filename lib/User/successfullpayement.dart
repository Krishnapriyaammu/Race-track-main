// import 'package:flutter/material.dart';
// import 'package:loginrace/User/navigationuser.dart';
// import 'package:loginrace/User/statustrackbooking.dart';
// import 'package:loginrace/User/viewevents.dart';


// class SuccessfullPayment extends StatefulWidget {
//   var name;
//   var email;
//   var phone;
//   String uid;
  
//   var level1;

//    SuccessfullPayment({super.key, required this.name, required this. email, required this. phone, required this. uid, required this. level1, });

//   @override
//   State<SuccessfullPayment> createState() => _SuccessfullPaymentState();
// }

// class _SuccessfullPaymentState extends State<SuccessfullPayment> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue, 
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.check_circle,
//               color: Color.fromARGB(255, 20, 167, 37),
//               size: 100.0,
//             ),
//             SizedBox(height: 20.0),
//             Text(
//               'Payment Successful!',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black, 
//               ),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return StatusTrack(name: widget.name,email:widget.email,phone: widget.phone, uid: 'uid', level1: widget.level1,     
// );
//                 }));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue, 
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//               ),
//               child: Text(
//                 'OK',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.white, 
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }