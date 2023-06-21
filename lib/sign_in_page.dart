import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Add focus node
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();

    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
          child: Form(
            key: formKey,
            child: AutofillGroup(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    Image.asset(
                      'assets/westway.png',
                      width: screenSize.width * 0.9,
                      height: screenSize.height * 0.11,
                      fit: BoxFit.contain,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // Move focus to next
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode, // assign focus node
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        // Perform action when user hits 'enter' in password field.
                        if (formKey.currentState!.validate()) {
                          context.read<AuthService>().signIn(
                              _emailController.text, _passwordController.text);
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.019,
                    ),
                    ElevatedButton(
                      child: const Text("Sign In"),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          String? error = await context
                              .read<AuthService>()
                              .signIn(_emailController.text,
                                  _passwordController.text);

                          if (error != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(error),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 27,
                      child: TextButton(
                        onPressed: () {
                          // TODO: implement forgot password
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      height: 34,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 16),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'New Employee?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 1, 1, 1),
                                fontSize: 11.0,
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              'Register Now',
                              style: TextStyle(
                                color: Color.fromARGB(255, 1, 8, 203),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 34,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/offerings_screen');
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                          ),
                        ),
                        child: const Column(
                          children: [
                            SizedBox(height: 0),
                            Text(
                              'Browse Offerings',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
