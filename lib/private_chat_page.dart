// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'add_users_chat_page.dart';

// class PrivateChatPage extends StatefulWidget {
//   final UserModel user;

//   const PrivateChatPage({required this.user});

//   @override
//   _PrivateChatPageState createState() => _PrivateChatPageState();
// }

// class _PrivateChatPageState extends State<PrivateChatPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat withh ${widget.user.displayName}'),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: _firestore
//                     .collection('chats')
//                     .doc(widget.user.displayName)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(
//                       child: SpinKitFadingCircle(
//                         color: Color.fromARGB(255, 6, 3, 125),
//                         size: 50.0,
//                       ),
//                     );
//                   }

//                   final messages = (snapshot.data!.data()
//                       as Map<String, dynamic>)['messages'] as List<dynamic>;

//                   return ListView.builder(
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       final message = messages[index];
//                       final isCurrentUser = message['sender'] ==
//                           'currentUser'; // Replace 'currentUser' with the current user's displayName

//                       return ListTile(
//                         title: Text(message['text']),
//                         subtitle: Text(message['timestamp']),
//                         leading:
//                             isCurrentUser ? null : Icon(Icons.account_circle),
//                         trailing:
//                             isCurrentUser ? Icon(Icons.account_circle) : null,
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration:
//                           InputDecoration(hintText: 'Write a message...'),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: () async {
//                       if (_messageController.text.isNotEmpty) {
//                         await _firestore
//                             .collection('chats')
//                             .doc(widget.user.displayName)
//                             .set({
//                           'messages': FieldValue.arrayUnion([
//                             {
//                               'sender':
//                                   'currentUser', // Replace 'currentUser' with the current user's displayName
//                               'text': _messageController.text,
//                               'timestamp': Timestamp.now(),
//                             },
//                           ]),
//                         }, SetOptions(merge: true)); // Add this

//                         _messageController.clear();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
