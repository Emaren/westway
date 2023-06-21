import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/westway.png', width: 380, height: 100),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                context.read<AuthService>().signOut(context);
              },
              child: const Text('Log Out'),
            ),
          ],
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
