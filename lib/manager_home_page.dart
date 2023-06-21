import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'auth_service.dart';
import 'hours/hours_entry_page.dart';
import 'manager_app_bar.dart';
import 'manager_app_baro.dart';
import 'mini timesheet widget/mini_timesheet_utils.dart';
import 'review_timesheet_page.dart';
import 'sign_up_page.dart';
import 'timesheet_data.dart';
import 'user_list_page.dart';
import 'video_page.dart';

class ManagerHomePage extends StatefulWidget {
  final List<TimesheetData>? timesheetData;
  final String uid;
  final Widget appBar;
  final Function updateAppBar;

  const ManagerHomePage({
    Key? key,
    this.timesheetData,
    required this.uid,
    required this.appBar,
    required this.updateAppBar,
  }) : super(key: key);

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  String? role;
  late final displayName;
  bool _isOriginalAppBarActive = true;

  String title = 'Manager Home';
  final List<String> userRoles = [
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
  List<PayDate> payDates = [];

  List<Map<String, dynamic>> hourEntriesData = [];

  String userId = '';
  String userDisplayName = 'Unknown';
  DateTime currentPayPeriodStart = calculateStartDate();
  List<DateTime> payPeriodDates = [];

  @override
  void initState() {
    super.initState();
    payPeriodDates = generatePayPeriodDates(currentPayPeriodStart);
    super.initState();
  }

  PreferredSizeWidget _buildManagerAppBaro() {
    return ManagerAppBaro(uid: widget.uid);
  }

  PreferredSizeWidget _buildOriginalAppBar() {
    return ManagerAppBar(uid: widget.uid);
  }

  void updateAppBar(bool isOriginal) {
    setState(() {
      _isOriginalAppBarActive = isOriginal;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building ManagerHomePage');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: widget.appBar, // Use the appBar widget passed from HiddenDrawer
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
                          nameController: _displayNameController,
                          userRoles: const [
                            'Admin',
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
                            'Vendor'
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 192, 1, 1),
                                    Color.fromARGB(255, 88, 0, 0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds);
                              },
                              child: const Icon(
                                Icons.people,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Users',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ],
                        )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 95, 101, 106),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 192, 1, 1),
                                  Color.fromARGB(255, 88, 0, 0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.person_add_alt_1,
                              size: 48,
                              color: Color.fromARGB(255, 188, 188, 188),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Create User',
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
                        builder: (context) => ReviewTimesheetPage(
                          timesheetData: widget.timesheetData ?? [],
                          uid: widget.uid,
                          authService: _authService,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Review Timesheets',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Review Tickets &\n Safety Documents',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View Jobs List &\n Assign Jobs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
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
                          size: 35,
                          // color: Color.fromARGB(255, 132, 14, 14)
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Westway Video Chat',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SimpleHiddenDrawerController.of(context).toggle();
        },
        child: const Icon(Icons.menu),
      ),
    );
  }
}
