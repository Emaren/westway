import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_users_chat_page.dart';
import 'auth_service.dart';
import 'roadmap_page.dart';

class ManagerAppBaro extends StatelessWidget implements PreferredSizeWidget {
  final String uid;
  const ManagerAppBaro({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        key: key,
        // title: title,
        // backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey,
                Colors.blueGrey,
                // Color.fromARGB(255, 88, 0, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.wifi, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.gas_meter_outlined,
                        color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                      icon: const Icon(Icons.sms_outlined, color: Colors.black),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AddUsersChatPage())); // Replace with your page
                      }),
                  IconButton(
                    icon: const Icon(Icons.security),
                    onPressed: () {},
                  ),
                  IconButton(
                      icon: const Icon(Icons.fork_right_rounded),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RoadmapPage()));
                      }),
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
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
