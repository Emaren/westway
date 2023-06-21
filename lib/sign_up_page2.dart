// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'auth_service.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();

//   final _displayNameController = TextEditingController();
//   String? _selectedRole;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize:
//               const Size.fromHeight(89.0), // Adjust the height as needed
//           child: AppBar(
//             backgroundColor: Colors.white,
//             flexibleSpace: LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//                 final screenSize = MediaQuery.of(context).size;
//                 final appBarHeight = AppBar().preferredSize.height;
//                 final availableHeight = constraints.maxHeight - appBarHeight;
//                 final imageHeight =
//                     availableHeight * .94; // Adjust the ratio as needed
//                 final padding = screenSize.width * 0.03;

//                 return Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             bottom: padding), // Padding under the image
//                         child: Image.asset(
//                           'assets/westway.png',
//                           height: imageHeight,
//                           fit: BoxFit
//                               .contain, // using BoxFit.contain to keep the aspect ratio
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             bottom: PreferredSize(
//               preferredSize:
//                   const Size.fromHeight(2.0), // Adjust the height as needed
//               child: Container(
//                 color: Colors.white,
//                 // height: 2.0, // Adjust the height as needed
//               ),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: const OutlineInputBorder(),
//                       prefixIcon: IconTheme(
//                         data: const IconThemeData(
//                             color: Colors
//                                 .white), // Set the default icon color to white
//                         child: ShaderMask(
//                           shaderCallback: (Rect bounds) {
//                             return const LinearGradient(
//                               colors: [
//                                 Color.fromARGB(255, 39, 39, 39),
//                                 Color.fromARGB(255, 174, 174, 174),
//                               ],
//                               tileMode: TileMode.mirror,
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ).createShader(bounds);
//                           },
//                           child: const Icon(Icons.email),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // const SizedBox(height: 12),
//                   // TextField(
//                   //   controller: _firstNameController,
//                   //   decoration: const InputDecoration(
//                   //     labelText: 'First Name',
//                   //     border: OutlineInputBorder(),
//                   //     prefixIcon: Icon(Icons.person),
//                   //   ),
//                   // ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _displayNameController,
//                     decoration: InputDecoration(
//                       labelText: 'First Name',
//                       border: const OutlineInputBorder(),
//                       prefixIcon: IconTheme(
//                         data: const IconThemeData(
//                             color: Colors
//                                 .white), // Set the default icon color to white
//                         child: ShaderMask(
//                           shaderCallback: (Rect bounds) {
//                             return const LinearGradient(
//                               colors: [
//                                 Color.fromARGB(255, 39, 39, 39),
//                                 Color.fromARGB(255, 174, 174, 174),
//                               ],
//                               tileMode: TileMode.mirror,
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ).createShader(bounds);
//                           },
//                           child: const Icon(Icons.person),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _lastNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Last Name',
//                       border: const OutlineInputBorder(),
//                       prefixIcon: IconTheme(
//                         data: const IconThemeData(
//                             color: Colors
//                                 .white), // Set the default icon color to white
//                         child: ShaderMask(
//                           shaderCallback: (Rect bounds) {
//                             return const LinearGradient(
//                               colors: [
//                                 Color.fromARGB(255, 39, 39, 39),
//                                 Color.fromARGB(255, 174, 174, 174),
//                               ],
//                               tileMode: TileMode.mirror,
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ).createShader(bounds);
//                           },
//                           child: const Icon(Icons.person),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       border: const OutlineInputBorder(),
//                       prefixIcon: IconTheme(
//                         data: const IconThemeData(
//                             color: Colors
//                                 .white), // Set the default icon color to white
//                         child: ShaderMask(
//                           shaderCallback: (Rect bounds) {
//                             return const LinearGradient(
//                               colors: [
//                                 Color.fromARGB(255, 39, 39, 39),
//                                 Color.fromARGB(255, 174, 174, 174),
//                               ],
//                               tileMode: TileMode.mirror,
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ).createShader(bounds);
//                           },
//                           child: const Icon(Icons.lock),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       labelText: 'Role',
//                       border: OutlineInputBorder(),
//                     ),
//                     hint: const Text('Select Role'),
//                     value: _selectedRole,
//                     items: [
//                       'Owner',
//                       'Manager',
//                       'Administration',
//                       'Accounting',
//                       'Secretary',
//                       'Supervisor',
//                       'Employee',
//                       'Sales',
//                       'Field Tech',
//                       'Shop Tech',
//                       'Tech',
//                       'Technician',
//                       'Client',
//                       'Customer',
//                       'Vendor',
//                       'Guest'
//                     ].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           _selectedRole = newValue;
//                         });
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final authentication =
//                           Provider.of<AuthService>(context, listen: false);

//                       try {
//                         UserCredential? userCredential =
//                             await authentication.signUpWithEmail(
//                                 _emailController.text,
//                                 _passwordController.text,
//                                 _displayNameController.text,
//                                 _firstNameController.text,
//                                 _lastNameController.text,
//                                 _selectedRole!);

//                         if (userCredential != null) {
//                           Navigator.pop(context);
//                         } else {
//                           // Show an error message
//                         }
//                       } catch (e) {
//                         // Show an error message
//                       }
//                     },
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.white),
//                       foregroundColor:
//                           MaterialStateProperty.all<Color>(Colors.black),
//                     ),
//                     child: const Text('Sign In'),
//                   ),
//                 ])));
//   }
// }
