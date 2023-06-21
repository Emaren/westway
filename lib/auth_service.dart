import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'hours/hours_entry_page.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  User? get currentUser => _user;
  String? get currentUserId => _auth.currentUser?.uid;

  String? currentUserDisplayName;

  AuthService() {
    print('Initializing AuthService...');
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _user = null;
        currentUserDisplayName = null;
        print('No user currently signed in.');
      } else {
        _user = user;
        print('User signed in: ${user.uid}');
        print('User ID: ${user.uid}');
        _fetchCurrentUserDisplayName();
      }
      notifyListeners();
    });
  }

  Future<String> getUserDisplayName(String uid) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await firestore.collection('users').doc(uid).get();
      String? displayName =
          (userDocSnapshot.data() as Map<String, dynamic>)['displayName'];

      return displayName ?? 'Unknown user';
    } catch (e) {
      print(e);
      return 'Unknown user';
    }
  }

  Future<void> _fetchCurrentUserDisplayName() async {
    currentUserDisplayName = await getCurrentUserDisplayNameFromFirestore();
  }

  Future<String?> getCurrentUserDisplayNameFromFirestore() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String? displayName = await getUserDisplayName(user.uid);

      return displayName;
    } else {
      return null;
    }
  }

  Future<Map<String, String?>> fetchUserDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _userCollection.doc(currentUser.uid).get();
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      String displayName = data?['displayName'] ?? 'N/A';
      String firstName = data?['firstName'] ?? 'N/A';
      String role = data?['role'] ?? 'N/A';

      return {'displayName': displayName, 'firstName': firstName, 'role': role};
    }
    return {'displayName': null, 'firstName': null, 'role': null};
  }

  Future<UserCredential> signUpWithEmail(
      String email,
      String password,
      String displayName,
      String firstName,
      String lastName,
      String role) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _userCollection.doc(userCredential.user!.uid).set({
        'creationTime': FieldValue.serverTimestamp(),
        'email': email,
        'displayName': displayName,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      });

      notifyListeners();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      notifyListeners();

      rethrow;
    }
  }

  Future<void> navigateToHoursEntryPage(BuildContext context) async {
    if (_user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HoursEntryPage(),
          ));
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      print('Attempting to sign in user: $email...');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      DocumentSnapshot userDoc =
          await _userCollection.doc(userCredential.user!.uid).get();

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      String displayName = data?['displayName'] ?? 'N/A';
      String firstName = data?['firstName'] ?? 'N/A';
      String role = data?['role'] ?? 'N/A';

      print(
          'User details fetched from Firestore: ${userCredential.user!.uid}, displayName=$displayName, firstName=$firstName, role=$role');

      print(
          'User signed in successfully: ID=${userCredential.user?.uid}, displayName=$displayName, firstName=$firstName, role=$role');

      notifyListeners();

      return null;
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in user: ${e.code}, ${e.message}');
      notifyListeners();

      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return 'Failed to sign in. Please try again.';
      }
    } catch (e) {
      print('An unknown error occurred: $e');
      notifyListeners();
      return 'An unknown error occurred. Please try again.';
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.delete();
      print('User deleted: ${user.uid}');
    } else {
      throw Exception('No user is signed in.');
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> getUserDocRef(
      String uid) async {
    DocumentReference<Map<String, dynamic>> userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);
    return userDocRef;
  }
}
