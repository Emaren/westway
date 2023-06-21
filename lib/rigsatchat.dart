import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'add_users_chat_page.dart';
import 'video_player_item.dart';

class RigSatChat extends StatefulWidget {
  const RigSatChat({super.key});

  @override
  State<RigSatChat> createState() => _RigSatChatState();
}

class _RigSatChatState extends State<RigSatChat> {
  final TextEditingController _messageController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy HH:mm');
  final FirebaseService _firebaseService = FirebaseService();
  final MessageContentBuilder _messageContentBuilder = MessageContentBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[1],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseService.getMessageStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SpinKitFadingGrid(
                        color: Color.fromARGB(255, 27, 2, 191),
                        size: 50.0,
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data!.docs[index];
                      return FutureBuilder<String>(
                        future: _firebaseService
                            .fetchDisplayName(message['userId']),
                        builder: (context, displayNameSnapshot) {
                          if (!displayNameSnapshot.hasData) {
                            return const SpinKitSpinningCircle(
                              color: Colors.blueGrey,
                              size: 50.0,
                            );
                          }

                          final timestamp = message['timestamp'] != null
                              ? (message['timestamp'] as Timestamp).toDate()
                              : DateTime.now();

                          return ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayNameSnapshot.data!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 6, 119),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _messageContentBuilder
                                          .buildMessageContent(message),
                                      const SizedBox(height: 4),
                                      Text(
                                        _dateFormat.format(timestamp),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message',
                      ),
                      onSubmitted: (_) {
                        _firebaseService.sendMessage(
                            text: _messageController.text);
                        _messageController.clear();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _firebaseService.sendMessage(
                          text: _messageController.text);
                      _messageController.clear();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () async {
                      final imageFile = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (imageFile != null) {
                        await _firebaseService.sendMediaMessage(
                          file: File(imageFile.path),
                          mediaType: 'image',
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam),
                    onPressed: () async {
                      final videoFile = await ImagePicker()
                          .getVideo(source: ImageSource.gallery);
                      if (videoFile != null) {
                        await _firebaseService.sendMediaMessage(
                          file: File(videoFile.path),
                          mediaType: 'video',
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddUsersChatPage()),
                      );
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

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> fetchDisplayName(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    return userDoc.data()?['displayName'] ?? '';
  }

  Future<void> sendMessage(
      {String? text, String? imageUrl, String? videoUrl}) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('User is not signed in');
      return;
    }
    await _firestore.collection('messages').add({
      'text': text ?? '',
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user.uid,
    });
  }

  Future<void> sendMediaMessage({File? file, String? mediaType}) async {
    final user = _auth.currentUser;
    if (user == null || file == null || mediaType == null) {
      print('User is not signed in or file or mediaType is null');
      return;
    }

    final fileName =
        '${user.uid}/${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}';
    final taskSnapshot = await _storage.ref(fileName).putFile(file);
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    if (mediaType == 'image') {
      await sendMessage(imageUrl: downloadUrl);
    } else if (mediaType == 'video') {
      await sendMessage(videoUrl: downloadUrl);
    }
  }

  Stream<QuerySnapshot> getMessageStream() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

class MessageContentBuilder {
  Widget buildMessageContent(DocumentSnapshot message) {
    Map<String, dynamic> messageData =
        message.data() as Map<String, dynamic>? ?? {};

    final String text = messageData['text'] ?? '';
    final String imageUrl = messageData['imageUrl'] ?? '';
    final String videoUrl = messageData['videoUrl'] ?? '';

    if (imageUrl.isNotEmpty) {
      return Image.network(imageUrl);
    } else if (videoUrl.isNotEmpty) {
      return VideoPlayerItem(url: videoUrl);
    } else {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      );
    }
  }
}
