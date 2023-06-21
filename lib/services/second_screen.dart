import 'package:flutter/material.dart';
import 'services_carousel.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        color: Colors.grey[50],
        child: const ServicesCarousel(),
      ),
    );
  }
}
