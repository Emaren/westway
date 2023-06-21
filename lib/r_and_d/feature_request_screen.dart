import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'billing_carousel.dart';
import 'top_way_carousel.dart';

class FeatureRequestScreen extends StatefulWidget {
  const FeatureRequestScreen({super.key});

  @override
  _FeatureRequestScreenState createState() => _FeatureRequestScreenState();
}

class _FeatureRequestScreenState extends State<FeatureRequestScreen> {
  final List<List<TextEditingController>> _controllers = List.generate(
    5,
    (index) => List.generate(
      7,
      (index) => TextEditingController(),
    ),
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _initData();
  }

  Future<void> _initData() async {
    for (var j = 0; j < 3; j++) {
      for (var i = 0; i < _controllers[j].length; i++) {
        DocumentSnapshot doc = await _firestore
            .collection('featureRequests${j + 1}')
            .doc('request$i')
            .get();

        var data = doc.data() as Map<String, dynamic>?;

        _controllers[j][i].text =
            doc.exists && data != null && data['text'] != null
                ? data['text']
                : '';
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Research & Development'),
      ),
      body: ListView(
        children: const [
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: TopWayCarousel(carouselIndex: 0),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: TopWayCarousel(carouselIndex: 1),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: TopWayCarousel(carouselIndex: 2),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: TopWayCarousel(carouselIndex: 3),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: TopWayCarousel(carouselIndex: 4),
          ),
          SizedBox(
            height: 700,
            child: BillingCarousel(),
          ),
        ],
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
