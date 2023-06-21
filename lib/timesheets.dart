import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'hours/hours_entry_page.dart';

class Timesheets extends StatefulWidget {
  const Timesheets({
    Key? key,
  }) : super(key: key);

  @override
  State<Timesheets> createState() => _TimesheetsState();
}

class _TimesheetsState extends State<Timesheets> {
  List<PayDate> payDates = [];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/westway.png', width: 380, height: 100),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => authService.navigateToHoursEntryPage(context),
                child: const Text('Hours'),
              ),
            ],
          ),
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
