import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'auth_service.dart';

class UserListPage extends StatefulWidget {
  final AuthService authService;

  const UserListPage({
    Key? key,
    required this.authService,
    required TextEditingController emailController,
    required TextEditingController nameController,
    required List<String> userRoles,
    required Null Function(dynamic BuildContext) createUser,
  }) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _usersStream;
  String? currentRole;
  static const allowedRoles = [
    'Owner',
    'Manager',
    'Administration',
    'Accounting',
    'Secretary',
    'Sales',
    'Supervisor',
    'Field Tech',
    'Shop Tech',
    'Tech',
    'Technician',
    'Employee',
    'Client',
    'Customer',
    'Vendor',
    'Guest'
  ];

  @override
  void initState() {
    super.initState();
    _usersStream = _firestore
        .collection('users')
        .orderBy('creationTime', descending: true)
        .snapshots();
    print('_usersStream set up'); // DEBUG LINE
    _loadCurrentRole();
  }

  void _loadCurrentRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      var userData = doc.data();
      if (userData != null && userData.containsKey('role')) {
        setState(() {
          currentRole = userData['role'];
          print('Current role loaded: $currentRole'); // DEBUG LINE
        });
      } else {
        print('Role field does not exist for user ${user.uid}');
      }
    } else {
      print('User not logged in'); // DEBUG LINE
    }
  }

  Future<void> _editUser(
      BuildContext context,
      String uid,
      String currentDisplayName,
      String currentRole,
      String currentEmail) async {
    String newDisplayName = currentDisplayName;
    String newRole = currentRole;
    String newEmail = currentEmail;
    String? editSelectedRole = currentRole;

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit User'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    initialValue: currentDisplayName,
                    decoration:
                        const InputDecoration(labelText: 'Display Name'),
                    onChanged: (value) {
                      newDisplayName = value;
                    },
                  ),
                  TextFormField(
                    initialValue: currentEmail,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      newEmail = value;
                    },
                  ),
                  DropdownButton<String>(
                    hint: const Text('Select Role'),
                    value: editSelectedRole,
                    items: ['Manager', 'Employee', 'Client', 'Customer']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        editSelectedRole = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  await _firestore.collection('users').doc(uid).update({
                    'displayName': newDisplayName,
                    'role': editSelectedRole,
                    'email': newEmail,
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // Future<void> deleteUser(String uid) async {
  //   try {
  //     await widget.authService.deleteUser(uid);
  //   } catch (e) {
  //     print("Error deleting user: $e");
  //     rethrow;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      backgroundColor: const Color.fromARGB(244, 192, 191, 191),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('Snapshot error: ${snapshot.error}'); // DEBUG LINE
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitPulsingGrid(
                      color: Color.fromARGB(255, 27, 2, 191),
                      size: 50.0,
                    ),
                  );
                }
                print(
                    'Snapshot data length: ${snapshot.data!.docs.length}'); // DEBUG LINE
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      print('User data $index: $data'); // DEBUG LINE

                      return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(19),
                          ),
                          color: const Color(0xFFF5F5F5),
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          child: const Icon(Icons.person),
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              data['displayName'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(data['role']),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      spacing: 8.0,
                                      alignment: WrapAlignment.center,
                                      children: <Widget>[
                                        Theme(
                                          data: ThemeData(
                                              iconTheme: const IconThemeData(
                                                  color: Colors.grey)),
                                          child: Builder(
                                            builder: (BuildContext context) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (currentRole ==
                                                          'Manager' ||
                                                      currentRole == 'Admin' ||
                                                      (_auth.currentUser!.uid ==
                                                          document.id)) ...[
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      onPressed: () {
                                                        _editUser(
                                                          context,
                                                          document.id,
                                                          data['displayName'],
                                                          data['currentRole'],
                                                          data['email'],
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      onPressed: () async {
                                                        // await deleteUser(
                                                        // document.id);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.video_call),
                                                    onPressed: () {
                                                      // Implement FaceTime action
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.email),
                                                    onPressed: () {
                                                      // Implement emailing action
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.chat),
                                                    onPressed: () {
                                                      // Implement messaging action
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.phone),
                                                    onPressed: () {
                                                      // Implement calling action
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])));
                    });
              })),
    );
  }
}
