// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:loginrace/User/successfullpayement.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PayementType extends StatefulWidget {
//   dynamic name;
//   dynamic email;
//   dynamic phone;
//   dynamic place;
//   dynamic level1;
//   String uid;
//    PayementType({super.key, required this. name, required this. email,required this.place, required this. phone, required this. uid, required this. level1, });

//   @override
//   State<PayementType> createState() => _PayementTypeState();
// }

// class _PayementTypeState extends State<PayementType> {
//   int? _selectedMethod;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue, 
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 16.0),
//               child: Center(
                
//                 child: Text(
//                    widget.level1 ?? 'amount not available',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView(
//                 children: ListTile.divideTiles(
//                   context: context,
//                   tiles: [
//                     _optionTile('Credit card / Debit card', Icons.credit_card, 0),
//                     _optionTile('Cash on delivery', Icons.money, 1),
//                     _optionTile('Paypal', Icons.payment, 2),
//                     _optionTile('Google wallet', Icons.account_balance_wallet, 3),
//                   ],
//                 ).toList(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: ElevatedButton(
//                 onPressed: () async{
//                     SharedPreferences sp = await SharedPreferences.getInstance();
//                       var userid = sp.getString('uid');
//                       print(userid);
//                     await FirebaseFirestore.instance.collection("user_track_booking").add({
//                          'name':widget.name,
//                          'email':widget.email,
//                          'phone':widget.phone,
//                          'place':widget.place,
//                          'uid': widget.uid, 
//                          'userid':userid ,
//                          'level1':widget.level1,

                           
                       

                         
//                      });
                  


//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return SuccessfullPayment(name:widget.name,email:widget.email,phone:widget.phone,uid:widget.uid,level1:widget.level1,
//                     );
//                   }));
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.blue),
//                   padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
//                   shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   )),
//                 ),
//                 child: Text('PAY', style: TextStyle(color: Colors.white, fontSize: 20)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   ListTile _optionTile(String title, IconData icon, int index) {
//     return ListTile(
//       title: Text(title),
//       leading: Icon(icon),
//       trailing: Radio(
//         value: index,
//         groupValue: _selectedMethod,
//         onChanged: (int? value) {
//           setState(() {
//             _selectedMethod = value;
//           });
//         },
//       ),
//     );
//   }
// }