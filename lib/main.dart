import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

import 'hours/editing_pay_date.dart';
import 'offerings_screen.dart';
import 'products/cart.dart';
import 'r_and_d/feature_request_screen.dart';
import 'hidden_drawer.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

void main() async {
  print('Starting the application...');
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');
  try {
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        );
    print('Firebase initialized successfully!');
  } catch (error) {
    print('Failed to initialize Firebase: $error');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditingPayDate(),
        ),
        ChangeNotifierProxyProvider<AuthService, Cart>(
          create: (context) => Cart('default'),
          update: (context, authService, previousCart) {
            if (authService.currentUser?.uid != previousCart?.uid) {
              print('Creating Cart for user: ${authService.currentUser!.uid}');
              return Cart(authService.currentUser!.uid);
            }
            return previousCart ?? Cart('default');
          },
        ),
        FutureProvider<Map<String, String?>>(
          create: (context) => Provider.of<AuthService>(context, listen: false)
              .fetchUserDetails(),
          initialData: const {'displayName': null, 'role': null},
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building MainApp...');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RigSat',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF13781D,
          <int, Color>{
            50: Color(0xFF13781D),
            100: Color(0xFF13781D),
            200: Color(0xFF13781D),
            300: Color(0xFF13781D),
            400: Color(0xFF13781D),
            500: Color(0xFF13781D),
            600: Color(0xFF13781D),
            700: Color(0xFF13781D),
            800: Color(0xFF13781D),
            900: Color(0xFF13781D),
          },
        ),
      ),
      routes: {
        '/': (context) => const AuthenticationWrapper(),
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => const SignInPage(),
        '/feature_request': (context) => const FeatureRequestScreen(),
        '/offerings_screen': (context) => OfferingsScreen(),
        '/hidden_drawer': (context) => const HiddenDrawer(
              uid: '',
            ),
        // '/tickets': (context) => Tickets(
        //       uid: 'ClhL1S8MV3Ww4fa45RvF6g10tP12',
        // ),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building AuthenticationWrapper...');
    final firebaseUser = context.watch<AuthService>().currentUser;

    if (firebaseUser != null) {
      print('User is authenticated: ${firebaseUser.uid}');
      return FutureBuilder<DocumentReference>(
        future: Provider.of<AuthService>(context, listen: false)
            .getUserDocRef(firebaseUser.uid),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentReference> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            DocumentReference<Map<String, dynamic>>? userDocRef =
                snapshot.data as DocumentReference<Map<String, dynamic>>?;
            // return DatabaseScroll(
            return const HiddenDrawer(
              uid: '',
              // context DatabaseScroll(),
              // title: '',
              // userDocRef: userDocRef,
            );
          } else {
            // while data is loading:
            return const CircularProgressIndicator();
          }
        },
      );
    }
    print('User is not authenticated. Showing SignInPage...');
    return const SignInPage();
  }
}
