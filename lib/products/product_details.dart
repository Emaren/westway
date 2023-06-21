import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cart.dart';
import 'cart_screen.dart';
import 'product.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    Provider.of<Cart>(context).itemCount.toString() ?? '0',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'BOOSTERS (850)',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print('Adding product to the cart...');
                      Provider.of<Cart>(context, listen: false).add(product);
                      print('Product added to the cart');
                    },
                    child: const Text('Add to cart'),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    child: const Text(
                      'Contact Tony for more information.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () async {
                      var emailUri = Uri(
                        scheme: 'mailto',
                        path: 'tony@emaren.ca',
                        query: 'subject=More%20Information%20Required',
                      );

                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      } else {
                        throw 'Could not launch $emailUri';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Share via Email
                          Share.share(
                              'Check out this product: ${product.name}');
                        },
                        icon: const Icon(Icons.email),
                      ),
                      IconButton(
                        onPressed: () {
                          // Share on Facebook
                          Share.share(
                              'Check out this product: ${product.name}');
                        },
                        icon: const Icon(Icons.facebook),
                      ),
                      IconButton(
                        onPressed: () {
                          // Share via SMS/Messaging
                          Share.share(
                              'Check out this product: ${product.name}');
                        },
                        icon: const Icon(Icons.message),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
