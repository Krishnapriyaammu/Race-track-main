// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loginrace/User/navigationuser.dart';
// import 'package:loginrace/User/viewracetrack.dart';

// class UserHome extends StatefulWidget {
//   const UserHome({super.key});

//   @override
//   State<UserHome> createState() => _UserHomeState();
// }

// class _UserHomeState extends State<UserHome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//  appBar: AppBar(
//         title: Text(
//           'HOME',
//           style: TextStyle(color: Color.fromARGB(255, 15, 15, 15)),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'WELCOME TO THE TRACK ',
//                 style: GoogleFonts.irishGrover(
//                     color: const Color.fromARGB(255, 163, 33, 185),
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30),
//                 child: Container(
//                   height: 100,
//                   width: 300,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundImage: AssetImage('Assets/image1.jpg'),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           //Expanded(child: Padding(padding: const EdgeInsets.all(2),)),
//                           Padding(
//                               padding: const EdgeInsets.only(left: 40),
//                               child: InkWell(onTap: (){
//                                 Navigator.push(context, MaterialPageRoute(builder:(context) {
//                             return NavigationUser();
//                           },));
//                               },
//                                 child: Text(
//                                   'Race Tracks',
//                                   style: GoogleFonts.irishGrover(
//                                       color: Color.fromARGB(255, 20, 20, 20),
//                                       fontSize: 25),
//                                 ),
//                               )),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: Container(
//                   height: 100,
//                   width: 300,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundImage: AssetImage('Assets/wrk3.jpg'),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           //Expanded(child: Padding(padding: const EdgeInsets.all(2),)),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 40),
//                             child: InkWell(onTap: (){
//                           //     Navigator.push(context, MaterialPageRoute(builder:(context) {
//                           //   return RentalProffesional_View();
//                           // },));

//                             },
//                               child: Text(
//                                 'Rentals',
//                                 style: GoogleFonts.irishGrover(
//                                     color: Color.fromARGB(255, 20, 20, 20),
//                                     fontSize: 25),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: Container(
//                   height: 100,
//                   width: 300,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundImage: AssetImage('Assets/makeup.webp'),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           //Expanded(child: Padding(padding: const EdgeInsets.all(2),)),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 40),
//                             child: InkWell(onTap: (){
//                           //     Navigator.push(context, MaterialPageRoute(builder:(context) {
//                           //   return MakeupProffesional_View();
//                           // },));

//                             },
//                               child: InkWell(onTap: () {
//                           //       Navigator.push(context, MaterialPageRoute(builder:(context) {
//                           //   return MakeupProffesional_View();
//                           // },));
//                               },
//                                 child: Text(
//                                   'Make up',
//                                   style: GoogleFonts.irishGrover(
//                                       color: Color.fromARGB(255, 20, 20, 20),
//                                       fontSize: 25),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: Container(
//                   height: 100,
//                   width: 300,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundImage: AssetImage('Assets/mehandi.png'),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           //Expanded(child: Padding(padding: const EdgeInsets.all(2),)),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 40),
//                             child: InkWell(onTap: (){
//                           //     Navigator.push(context, MaterialPageRoute(builder:(context) {
//                           //   return MehandiProffesional_View();
//                           // },));

//                             },
//                               child: InkWell(onTap: (){
//                           //       Navigator.push(context, MaterialPageRoute(builder:(context) {
//                           //   return MehandiProffesional_View();
//                           // },));
//                               },
//                                 child: Text(
//                                   'Mehandi',
//                                   style: GoogleFonts.irishGrover(
//                                       color: Color.fromARGB(255, 20, 20, 20),
//                                       fontSize: 25),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }