import 'package:flutter/material.dart';

import 'auth_service.dart';

class DeleteAccountPage extends StatefulWidget {
  final AuthService authService;

  const DeleteAccountPage({super.key, required this.authService});

  @override
  _DeleteAccountPageState createState() =>
      _DeleteAccountPageState(authService: authService);
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final AuthService _authService;
  String? _status;

  _DeleteAccountPageState({required AuthService authService})
      : _authService = authService;

  Future<void> _deleteAccount() async {
    try {
      await widget.authService.deleteAccount();
      await _authService.signOut(context);
      Navigator.pop(context, 'Account deleted successfully');
    } catch (e) {
      if (mounted) setState(() => _status = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete Account'),
            ),
            const SizedBox(height: 5),
            Text(_status ?? ''),
          ],
        ),
      ),
    );
  }
}
