import 'package:flutter/material.dart';

import 'offerings_screen.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // get device screen size

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/westway.png',
                width: screenSize.width * 0.96, // 96% of screen width
                height: screenSize.height * 0.1, // 10% of screen height
                fit: BoxFit.scaleDown,
              ),
            ),
            // Add OfferingsScreen() widget below, wrapped with Expanded
            Expanded(child: OfferingsScreen()),
          ],
        ),
      ),
    );
  }
}
