import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'package:provider/provider.dart';

import 'database_assets/assets.dart';
import 'auth_service.dart';
import 'firestore_mini_timesheet_widget.dart';
import 'log_out_page.dart';
import 'employee_home_page.dart';
import 'customer_home_page.dart';
import 'manager_app_bar.dart';
import 'manager_app_baro.dart';
import 'manager_home_page.dart';
import 'offerings_screen.dart';
import 'products/first_screen.dart';
import 'r_and_d/feature_request_screen.dart';
import 'rigsatchat.dart';
import 'services/second_screen.dart';
import 'settings_screen.dart';
import 'tickets/tickets.dart';
import 'timesheets.dart';

class HiddenDrawer extends StatefulWidget {
  final String uid;
  const HiddenDrawer({Key? key, required this.uid}) : super(key: key);

  @override
  _HiddenDrawerState createState() => _HiddenDrawerState(uid: uid);
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No user';
  bool _isBlack = false;
  bool _isOriginalAppBarActive = true;
  ManagerAppBar originalAppBar = const ManagerAppBar(
    uid: '',
  );
  ManagerAppBaro managerAppBaro = const ManagerAppBaro(
    uid: '',
  );
  late final AuthService authService;
  late String uid;
  _HiddenDrawerState({required this.uid});

  void updateAppBar(bool isOriginal) {
    setState(() {
      _isOriginalAppBarActive = isOriginal;
    });
  }

  @override
  void initState() {
    super.initState();
    print('HiddenDrawerState initState');
    uid = widget.uid;
    authService = Provider.of<AuthService>(context,
        listen: false); // Assign AuthService instance here
  }

  @override
  Widget build(BuildContext context) {
    print('HiddenDrawerState build');
    final userDetails =
        Provider.of<AuthService>(context); // you get the instance here

    Widget homePage = const SizedBox.shrink();

    return FutureBuilder<Map<String, String?>>(
      future: userDetails.fetchUserDetails(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, String?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitFadingGrid(
              color: Color.fromARGB(255, 27, 2, 191),
              size: 50.0,
            ),
          );
        } else {
          String? displayName = snapshot.data?['displayName']?.trim();
          String? firstName = snapshot.data?['firstName']?.trim();
          String? role = snapshot.data?['role'];
          print(
              'DisplayName: $displayName, FirstName: $firstName, Role: $role');
          String? displayedName =
              displayName?.isEmpty ?? true ? firstName : displayName;

          print('DisplayedName after check: $displayedName');

          switch (role) {
            case 'Admin':
            case 'Owner':
            case 'Manager':
            case 'Administration':
            case 'Accounting':
            case 'Secretary':
            case 'Supervisor':
              homePage = ManagerHomePage(
                uid: uid, // Pass the uid to the ManagerHomePage
                appBar:
                    _isOriginalAppBarActive ? originalAppBar : managerAppBaro,
                updateAppBar: updateAppBar,
              );
              break;
            case 'Employee':
            case 'Sales':
            case 'Field Tech':
            case 'Shop Tech':
            case 'Tech':
            case 'Technician':
              homePage = const EmployeeHomePage(
                role: '',
              );
              break;
            case 'Client':
            case 'Customer':
            case 'Vendor':
            case 'Guest':
              homePage = const CustomerHomePage();
              break;
            case '' || null:
              homePage = OfferingsScreen();

            default:
              break;
          }

          List<ScreenHiddenDrawer> items = [
            ScreenHiddenDrawer(
              ItemHiddenMenu(
                name: '$displayedName, $role',
                baseStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                selectedStyle: const TextStyle(),
              ),
              Scaffold(
                body: homePage,
              ),
            ),
            ScreenHiddenDrawer(
              ItemHiddenMenu(
                  name: 'Timesheets',
                  baseStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 19),
                  selectedStyle: const TextStyle(color: Colors.white)),
              const Timesheets(),
            ),
            if ([
              'Admin',
              'Owner',
              'Manager',
              'Administration',
              'Accounting',
              'Secretary',
              'Supervisor'
            ].contains(role)) ...[
              ScreenHiddenDrawer(
                ItemHiddenMenu(
                    name: 'Review Hours',
                    baseStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                    selectedStyle: const TextStyle(color: Colors.white)),
                Scaffold(
                  body: Center(
                    child: FirestoreMiniTimesheetWidget(),
                  ),
                ),
              ),
            ],
            if (role == 'Admin' ||
                role == 'Owner' ||
                role == 'Manager' ||
                role == 'Administration' ||
                role == 'Accounting' ||
                role == 'Secretary' ||
                role == 'Supervisor' ||
                role == 'Employee' ||
                role == 'Sales' ||
                role == 'Field Tech' ||
                role == 'Shop Tech' ||
                role == 'Tech' ||
                role == 'Technician') ...[
              ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'Assets',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const Assets(
                    title: '',
                    userDocRef: null,
                  )),
              ScreenHiddenDrawer(
                ItemHiddenMenu(
                    name: 'Tickets',
                    baseStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                    selectedStyle: const TextStyle(color: Colors.white)),
                Scaffold(
                    // appBar: AppBar(
                    //   actions: <Widget>[
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //       child: LayoutBuilder(
                    //         builder: (context, constraints) {
                    //           return Center(
                    //             child: Container(
                    //               height: constraints.maxHeight * 0.7,
                    //               // width: constraints.maxWidth * 0.7,
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 25.0),
                    //               decoration: BoxDecoration(
                    //                 color: Colors.white,
                    //                 borderRadius: BorderRadius.circular(30.0),
                    //               ),
                    //               child: const Row(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: <Widget>[
                    //                   Icon(Icons.search, color: Colors.grey),
                    //                   Padding(
                    //                     padding: EdgeInsets.all(8.0),
                    //                     child: SizedBox(
                    //                       width: 120,
                    //                       child: TextField(
                    //                         decoration: InputDecoration(
                    //                             border: InputBorder.none,
                    //                             hintText: ''),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //     IconButton(
                    //       icon: const Icon(Icons.arrow_back_ios_new_sharp),
                    //       iconSize: 20,
                    //       onPressed: () {},
                    //     ),
                    //     IconButton(
                    //       icon: const Icon(Icons.add_rounded),
                    //       iconSize: 30,
                    //       onPressed: () {},
                    //     ),
                    //     IconButton(
                    //       icon: const Icon(Icons.account_circle),
                    //       onPressed: () {},
                    //     ),
                    //     Stack(
                    //       children: <Widget>[
                    //         IconButton(
                    //           icon: const Icon(Icons.notifications_none),
                    //           onPressed: () {},
                    //         ),
                    //         Positioned(
                    //           top: 8.0,
                    //           right: 8.0,
                    //           child: Container(
                    //             padding: const EdgeInsets.all(2.0),
                    //             decoration: BoxDecoration(
                    //               color: const Color.fromARGB(255, 194, 13, 0),
                    //               borderRadius: BorderRadius.circular(10.0),
                    //             ),
                    //             constraints: const BoxConstraints(
                    //               minWidth: 14.0,
                    //               minHeight: 14.0,
                    //             ),
                    //             child: const Text(
                    //               '10+',
                    //               style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 8.0,
                    //               ),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    body: Tickets(
                  uid: uid,
                  // authService: authService,
                )),
              ),
              ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'WestwayChat',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const RigSatChat()),
              ScreenHiddenDrawer(
                  ItemHiddenMenu(
                      name: 'R&D',
                      baseStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                      selectedStyle: const TextStyle(color: Colors.white)),
                  const FeatureRequestScreen()),
              ScreenHiddenDrawer(
                ItemHiddenMenu(
                    name: 'Rentals',
                    baseStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                    selectedStyle: const TextStyle(color: Colors.white)),
                const Scaffold(
                  body: Center(
                    child: FirstScreen(),
                  ),
                ),
              ),
              ScreenHiddenDrawer(
                ItemHiddenMenu(
                    name: 'Services',
                    baseStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                    selectedStyle: const TextStyle(color: Colors.white)),
                const Scaffold(
                  body: Center(
                    child: SecondScreen(),
                  ),
                ),
              ),
            ],
            if (role == 'Client' ||
                role == 'Customer' ||
                role == 'Vendor' ||
                role == 'Guest') ...[
              ScreenHiddenDrawer(
                ItemHiddenMenu(
                    name: 'Rentals',
                    baseStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                    selectedStyle: const TextStyle(color: Colors.white)),
                const Scaffold(
                  body: Center(
                    child: FirstScreen(),
                  ),
                ),
              ),
              ScreenHiddenDrawer(
                ItemHiddenMenu(
                    name: 'Services',
                    baseStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                    selectedStyle: const TextStyle(color: Colors.white)),
                const Scaffold(
                  body: Center(
                    child: SecondScreen(),
                  ),
                ),
              ),
            ],
            ScreenHiddenDrawer(
                ItemHiddenMenu(
                    name: 'Settings',
                    baseStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                    selectedStyle: const TextStyle(color: Colors.white)),
                const SettingsScreen()),
            ScreenHiddenDrawer(
                ItemHiddenMenu(
                    name: "Log Out",
                    baseStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                    colorLineSelected: Colors.blue,
                    selectedStyle: const TextStyle(color: Colors.white)),
                const LogOutPage())
          ];

          return HiddenDrawerMenu(
            backgroundColorMenu: Colors.blueGrey,
            backgroundColorAppBar: Colors.blueGrey,
            screens: items,
            leadingAppBar: Icon(
              Icons.menu,
              color: _isBlack ? Colors.black : Colors.white,
            ),
            tittleAppBar: LayoutBuilder(
              builder: (context, constraints) {
                final imageWidth = MediaQuery.of(context).size.height * 0.06;
                final textWidth = constraints.maxWidth - imageWidth;
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, right: textWidth / 7),
                        child: Text(
                          '$displayedName, $role',
                          style: TextStyle(
                            color: _isBlack ? Colors.black : Colors.white,
                            fontSize: 20,
                            fontWeight:
                                _isBlack ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: imageWidth,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isOriginalAppBarActive =
                                  !_isOriginalAppBarActive;
                              _isBlack = !_isBlack;
                              updateAppBar(_isOriginalAppBarActive);
                            });
                            print(
                                'Image tapped, _isOriginalAppBarActive: $_isOriginalAppBarActive');
                          },
                          child: Image.asset(
                            'assets/westway.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
