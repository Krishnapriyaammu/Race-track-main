// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:loginrace/service/chat_service.dart';

// class Message extends StatefulWidget {
 
//   const Message({Key? key});

//   @override
//   State<Message> createState() => _MessageState();
// }

// class _MessageState extends State<Message> {
//   final List<Map<String, dynamic>> _messageRequests = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessageRequests();
//   }

//   Future<void> _fetchMessageRequests() async {
//     final QuerySnapshot messageRequestsSnapshot =
//         await FirebaseFirestore.instance.collection('user_designer_message').get();

//     final List<Map<String, dynamic>> requests = [];

//     for (final doc in messageRequestsSnapshot.docs) {
//       final Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
//       final String? userId = requestData['uid'];

//       if (userId != null) {
//         final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//             .collection('user_register')
//             .doc(userId)
//             .get();

//         if (userSnapshot.exists) {
//           final Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
//           final String? username = userData['name'];

//           if (username != null) {
//             requestData['username'] = username;
//             requests.add(requestData);
//           }
//         }
//       }
//     }

//     setState(() {
//       _messageRequests.addAll(requests.reversed);
//     });
//   }

//   Future<void> _sendReply(String? messageId) async {
//     if (messageId != null) {
//       final TextEditingController _replyController = TextEditingController();

//       final DocumentSnapshot messageSnapshot =
//           await FirebaseFirestore.instance.collection('user_community_message').doc(messageId).get();

//       if (messageSnapshot.exists) {
//         final Map<String, dynamic> messageData =
//             messageSnapshot.data() as Map<String, dynamic>;
//         final String? userId = messageData['uid'];
//         final String? messageText = messageData['text'] as String?;

//         if (userId != null && messageText != null) {
//           final String? reply = await showDialog<String>(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Reply to Message'),
//               content: TextField(
//                 controller: _replyController,
//                 decoration: InputDecoration(hintText: 'Enter your reply'),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context, _replyController.text);
//                   },
//                   child: Text('Send'),
//                 ),
//               ],
//             ),
//           );

//           _replyController.dispose();

//           if (reply != null && userId != null) {
//             await FirebaseFirestore.instance.collection('community_user_message').add({
//               'user_id': userId,
//               'message': reply,
//               'sender': 'Community',
//               'timestamp': Timestamp.now(),
//             });

//             await FirebaseFirestore.instance.collection('user_designer_message').doc(messageId).delete();
//           }
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Message Requests',
//           style: TextStyle(color: Colors.deepPurpleAccent),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messageRequests.length,
//               itemBuilder: (context, index) {
//                 final request = _messageRequests[index];
//                 final String? message = request['text'] as String?;
//                 final String? username = request['username'] as String?;
//                 final String? messageId = request['message_id'] as String?;

//                 return ListTile(
//                   title: Text(message != null ? message : 'No message'),
//                   subtitle: Text(username != null ? username : 'Unknown user'),
//                   trailing: IconButton(
//                     icon: Icon(Icons.check),
//                     onPressed: () {
//                       _sendReply(messageId);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }