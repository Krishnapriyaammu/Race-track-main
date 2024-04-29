// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loginrace/User/ticketbookingstatus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// class ShoppingCart extends StatefulWidget {
//   final String name;
//   final double price;
//   final bool isVIP;
//   final int generalTickets; // Total number of general tickets
//   final int childTickets; // Total number of child tickets
//   final String rt_id;

//   ShoppingCart({
//     Key? key,
//     required this.name,
//     required this.price,
//     required this.isVIP,
//     required this.rt_id,
//     required this.generalTickets,
//     required this.childTickets,
//   }) : super(key: key);

//   @override
//   State<ShoppingCart> createState() => _ShoppingCartState();
// }

// class _ShoppingCartState extends State<ShoppingCart> {
//   TextEditingController _ticketController = TextEditingController(text: '1');



//   @override
//  Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(
//         'Status',
//         style: GoogleFonts.poppins(),
//       ),
//       backgroundColor: Color.fromARGB(255, 96, 150, 212),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Ticket Details:',
//             style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Name: ${widget.name}',
//             style: GoogleFonts.poppins(fontSize: 18),
//           ),
//           SizedBox(height: 10),
          
//           if (widget.isVIP) SizedBox(height: 10),
//           Text(
//             widget.isVIP ? 'VIP Pass: Yes' : '',
//             style: GoogleFonts.poppins(fontSize: 18),
//           ),
//           SizedBox(height: 20),
//           Row(
//             children: [
//               Text(
//                 'Total Adult Tickets Booked:',
//                 style: GoogleFonts.poppins(fontSize: 18),
//               ),
//               SizedBox(width: 10),
//               Text(
//                 widget.generalTickets.toString(), // Display total general tickets
//                 style: GoogleFonts.poppins(fontSize: 18),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Text(
//                 'Total Child Tickets Booked:',
//                 style: GoogleFonts.poppins(fontSize: 18),
//               ),
//               SizedBox(width: 10),
//               Text(
//                 widget.childTickets.toString(), // Display total child tickets
//                 style: GoogleFonts.poppins(fontSize: 18),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Text(
//       'Total Tickets:',
//       style: GoogleFonts.poppins(fontSize: 18),
//     ),
//               SizedBox(width: 10),
              
//             ],
//           ),
//           SizedBox(height: 20),
         
//           SizedBox(height: 40),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                 child: Text(
//                   'Book Tickets',
//                   style: GoogleFonts.poppins(fontSize: 20),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }