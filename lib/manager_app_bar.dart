import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_users_chat_page.dart';
import 'auth_service.dart';
import 'roadmap_page.dart';

class ManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String uid;
  const ManagerAppBar({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
