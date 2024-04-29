// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:loginrace/User/payemettype.dart';
// import 'package:loginrace/User/statustrackbooking.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserTrackBooking extends StatefulWidget {
//   String rt_id;
//   var level1;
//    UserTrackBooking({Key? key, required this. rt_id, required this. level1, }) : super(key: key);

//   @override
//   State<UserTrackBooking> createState() => _UserTrackBookingState();
// }

// class _UserTrackBookingState extends State<UserTrackBooking> {
//   var name = TextEditingController();
//   var email = TextEditingController();
//   var phone = TextEditingController();
//   var place = TextEditingController();
//   var paymentOption = 'Google Pay'; 
//   // Default payment option
//   bool isBookingSubmitted = false;
// late String userId = '';

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     getUserDetails();
//     checkBookingStatus();
//   }

//   void getUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name.text = prefs.getString('name') ?? '';
//       // email.text = prefs.getString('email') ?? '';
//       // phone.text = prefs.getString('phone') ?? '';
//       // place.text = prefs.getString('place') ?? '';
//       userId = prefs.getString('uid') ?? '';
//     });
//   }
//   DateTime? selectedDate; // Variable to store selected date

//   // Function to show date picker
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(DateTime.now().year + 1),
//     );
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//       });
//   }
//  void checkBookingStatus() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   userId = prefs.getString('uid') ?? '';

//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('user_track_booking')
//       .where('userid', isEqualTo: userId)
//       .where('rt_id', isEqualTo: widget.rt_id)
//       .get();

//   if (querySnapshot.docs.isNotEmpty) {
//     setState(() {
//       isBookingSubmitted = true;
//     });
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text('Track Booking'),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Container(
//             width: double.infinity,
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.sports_motorsports,
//                       size: 64,
//                       color: Colors.blue,
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Join the Adventure!',
//                       style: TextStyle(
//                         fontSize: 24.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     buildTextFieldRow('Name', Icons.person, name, (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     }),
//                     buildTextFieldRow('Email', Icons.email, email, (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       return null;
//                     }),
//                     buildTextFieldRow('Phone', Icons.phone, phone, (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your phone';
//                       }
//                       return null;
//                     }),
//                     buildTextFieldRow('Place', Icons.place, place, (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your place';
//                       }
//                       return null;
//                     }),
//                       SizedBox(height: 20),
//                     buildDateField(), // Add date field here
//                     SizedBox(height: 20),
//                     buildPaymentDropdown(),
//                     SizedBox(height: 20),
//                     if (!isBookingSubmitted)
//                       ElevatedButton(
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             try {
//                               SharedPreferences sp = await SharedPreferences.getInstance();
//                               var userid = sp.getString('uid');

//                               await FirebaseFirestore.instance.collection('user_track_booking').add({
//                                 'name': name.text,
//                                 'email': email.text,
//                                 'phone': phone.text,
//                                 'place': place.text,
//                                 'date': selectedDate,
//                                 'payment_option': paymentOption,
//                                 'status': '0',
//                                 'rt_id': widget.rt_id,
//                                 'userid': userid,
//                               });

//                               setState(() {
//                                 isBookingSubmitted = true;
//                               });
//                             } catch (e) {
//                               print('Error saving data: $e');
//                               showDialog(
//                                 context: context,
//                                 builder: (context) => AlertDialog(
//                                   title: Text('Error'),
//                                   content: Text('Failed to save data. Please try again later.'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: Text('OK'),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(Colors.blue),
//                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20.0),
//                             ),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                           child: Text('Submit', style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     if (isBookingSubmitted)
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => StatusTrack(rt_id: widget.rt_id, userId: userId),
//                             ),
//                           );
//                         },
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(Colors.blue),
//                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20.0),
//                             ),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                           child: Text('View Status', style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextFieldRow(String label, IconData icon, TextEditingController controller, String? Function(String?)? validator) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: Colors.blue),
//               SizedBox(width: 10),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ],
//           ),
//           TextFormField(
//             controller: controller,
//             validator: validator,
//             onChanged: (value) {
//               setState(() {});
//             },
//             decoration: InputDecoration(
//               hintText: 'Enter your $label',
//               filled: true,
//               fillColor: Colors.grey[200],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildDateField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.calendar_today, color: Colors.blue),
//             SizedBox(width: 10),
//             Text(
//               'Date',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 8),
//         GestureDetector(
//           onTap: () => _selectDate(context),
//           child: AbsorbPointer(
//             child: TextFormField(
//               controller: TextEditingController(
//                 text: selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}' : '',
//               ),
//               validator: (value) {
//                 if (selectedDate == null) {
//                   return 'Please select a date';
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 hintText: 'Select Date',
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildPaymentDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.payment, color: Colors.blue),
//             SizedBox(width: 10),
//             Text(
//               'Payment Option',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: paymentOption,
//           onChanged: (String? newValue) {
//             setState(() {
//               paymentOption = newValue!;
//             });
//           },
//           items: <String>['Google Pay', 'Credit Card', 'PayPal']
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }