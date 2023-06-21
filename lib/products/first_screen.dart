import 'package:flutter/material.dart';

import 'product.dart';
import 'product_card.dart';
import 'product_data.dart';
import 'product_details.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final List<Product> _filteredProducts = products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 192, 1, 1),
                Color.fromARGB(255, 88, 0, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text("RigSat Rentals"),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // Implement sorting and filtering options here
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            product: _filteredProducts[index],
                          ),
                        ),
                      );
                    },
                    child: ProductCard(
                      product: _filteredProducts[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
