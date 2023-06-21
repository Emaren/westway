import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'auth_service.dart';

class AddUsersChatPage extends StatefulWidget {
  const AddUsersChatPage({super.key});

  @override
  _AddUsersChatPageState createState() => _AddUsersChatPageState();
}

class _AddUsersChatPageState extends State<AddUsersChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Chat'),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: SpinKitFadingCircle(
                  color: Color.fromARGB(255, 12, 8, 150),
                  size: 50.0,
                ),
              );
            }

            final users = snapshot.data!.docs
                .map((doc) => UserModel.fromDocument(doc))
                .toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserTile(user: user);
              },
            );
          },
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius:
            20.0, // Change this value to adjust the size of the CircleAvatar
        backgroundColor: Colors.white,
        child: Icon(
          Icons.account_circle,
          color: Colors.blueGrey,
          size: 40.0, // Change this value to adjust the size of the Icon
        ),
      ),
      title: Text(user.displayName),
      trailing: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivateChatPage(chatId: user.displayName),
            ),
          );
        },
        child: const Text('Chat'),
      ),
    );
  }
}

class UserModel {
  final String displayName;

  UserModel({
    required this.displayName,
  });

  // Factory method to create UserModel from DocumentSnapshot
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      displayName: doc['displayName'],
    );
  }
}

class PrivateChatPage extends StatefulWidget {
  final String chatId;

  const PrivateChatPage({super.key, required this.chatId});

  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  String currentUserDisplayName = "";

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserDisplayName();
  }

  Future<void> _fetchCurrentUserDisplayName() async {
    currentUserDisplayName =
        await AuthService().getCurrentUserDisplayNameFromFirestore() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.chatId}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(widget.chatId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.data() == null) {
                    return const Center(
                      child: SpinKitSpinningLines(
                        color: Color.fromARGB(255, 6, 8, 152),
                        size: 50.0,
                      ),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final messages = data['messages'] as List<dynamic>;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('No messages yet'),
                    );
                  }

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser = message['sender'] == 'currentUser';

                      return ListTile(
                        title: Text('${message['sender']}: ${message['text']}'),
                        subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm')
                            .format(message['timestamp'].toDate())),
                        leading: isCurrentUser
                            ? null
                            : const Icon(Icons.account_circle),
                        trailing: isCurrentUser
                            ? const Icon(Icons.account_circle)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration:
                          const InputDecoration(hintText: 'Write a message...'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (_messageController.text.isNotEmpty) {
                        DocumentReference chatDoc =
                            _firestore.collection('chats').doc(widget.chatId);

                        DocumentSnapshot chatDocSnapshot = await chatDoc.get();

                        if (!chatDocSnapshot.exists) {
                          await chatDoc.set({
                            'messages': [
                              {
                                'sender': currentUserDisplayName,
                                'text': _messageController.text,
                                'timestamp': Timestamp.now(),
                              }
                            ]
                          });
                        } else {
                          await chatDoc.update({
                            'messages': FieldValue.arrayUnion([
                              {
                                'sender': currentUserDisplayName,
                                'text': _messageController.text,
                                'timestamp': Timestamp.now(),
                              }
                            ])
                          });
                        }

                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
