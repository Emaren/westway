import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _displayNameController = TextEditingController();
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Create a User')),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  // const SizedBox(height: 12),
                  // TextField(
                  //   controller: _firstNameController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'First Name',
                  //     border: OutlineInputBorder(),
                  //     prefixIcon: Icon(Icons.person),
                  //   ),
                  // ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Select Role'),
                    value: _selectedRole,
                    items: [
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
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final authentication =
                          Provider.of<AuthService>(context, listen: false);

                      try {
                        UserCredential? userCredential =
                            await authentication.signUpWithEmail(
                                _emailController.text,
                                _passwordController.text,
                                _displayNameController.text,
                                _firstNameController.text,
                                _lastNameController.text,
                                _selectedRole!);

                        if (userCredential != null) {
                          Navigator.pop(context);
                        } else {
                          // Show an error message
                        }
                      } catch (e) {
                        // Show an error message
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                ])));
  }
}
