import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';

import 'add_users_chat_page.dart';
import 'auth_service.dart';
import 'firestore_mini_timesheet_widget.dart';
import 'user_list_page.dart';
import 'video_page.dart';

class EmployeeHomePage extends StatefulWidget {
  // final DocumentReference<Map<String, dynamic>>? userDocRef;
  final String role;
  // final String displayName;
  // final AuthService authService;

  const EmployeeHomePage({
    Key? key,
    // required this.userDocRef,
    // required this.displayName,
    // required this.authService,
    required this.role,
    // required Future<void> Function() onLogout,
    // required String title,
  }) : super(key: key);

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  static const IconData amp_stories_outlined =
      IconData(0xee73, fontFamily: 'MaterialIcons');
  static const IconData assignment =
      IconData(0xe0a5, fontFamily: 'MaterialIcons', matchTextDirection: true);
  static const IconData assignment_outlined =
      IconData(0xee98, fontFamily: 'MaterialIcons', matchTextDirection: true);
  static const IconData cell_tower_outlined =
      IconData(0xf05c7, fontFamily: 'MaterialIcons');
  static const IconData inventory_2_outlined =
      IconData(0xf134, fontFamily: 'MaterialIcons');
  static const IconData map_outlined =
      IconData(0xf1ae, fontFamily: 'MaterialIcons');
  static const IconData paid_outlined =
      IconData(0xf24e, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.wifi),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.gas_meter_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                        icon: const Icon(Icons.sms_outlined),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddUsersChatPage()));
                        }),
                    IconButton(
                      icon: const Icon(Icons.security),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.fork_right_rounded),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.speaker_phone),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        final authentication =
                            Provider.of<AuthService>(context, listen: false);
                        try {
                          await authentication.signOut(context);
                        } catch (e) {
                          // Handle exception
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cell_tower),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.desktop_windows),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.satellite_alt),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone_android),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserListPage(
                          authService: _authService,
                          emailController: _emailController,
                          nameController: _nameController,
                          userRoles: const [
                            'Owner',
                            'Manager',
                            'Administration',
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
                          ],
                          createUser: (BuildContext) {},
                        ),
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 33, 55, 73),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(26),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people, size: 45, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Users',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 122, 122, 122)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => SignUpPage(),
                  //     ),
                  //   );
                  // },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 95, 101, 106),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cell_tower_outlined,
                            size: 45,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tower Maps',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StreamBuilder<List<Map<String, dynamic>>>(
                                // stream: fetchAllHourEntriesData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Map<String, dynamic>>>
                                        hourEntriesSnapshot) {
                          return StreamBuilder<List<Map<String, String>>>(
                              // stream: fetchUsersData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Map<String, String>>>
                                      usersSnapshot) {
                            if (hourEntriesSnapshot.hasData &&
                                usersSnapshot.hasData) {
                              return FirestoreMiniTimesheetWidget();
                            } else {
                              return const SpinKitFadingGrid(
                                color: Color.fromARGB(255, 27, 2, 191),
                                size: 50.0,
                              );
                            }
                          });
                        }),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.paid_outlined,
                          size: 45,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Review Hours & Expenses',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ReviewTicketsPage(),
                    //   ),
                    // );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 45,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Review Tickets &\n Safety Documents',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const JobListPage(),
                    //     ),
                    //   );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 45,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Review Jobs',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.smartphone,
                          size: 45,
                          // color: Color.fromARGB(255, 132, 14, 14)
                        ),
                        SizedBox(height: 16),
                        Text(
                          'RigSat Video Chat',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => SmartPSS(),
                  //     ),
                  //   );
                  // },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 45,
                          // color: Color.fromARGB(255, 132, 14, 14)
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Directions',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
      // payDates: const [],
      // usersData: const [],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SimpleHiddenDrawerController.of(context).toggle();
        },
        child: const Icon(Icons.menu),
      ),
      // child: const SizedBox.shrink(),
    );
  }
}
