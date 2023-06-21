import 'package:flutter/material.dart';
import 'product.dart';
import 'product_details.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(product: product),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              10), // Adjust the value to control the roundness of the edges
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AspectRatio(
              aspectRatio:
                  .9, // Adjust the aspect ratio to accommodate more horizontal space
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(
                      10), // Match this value with the borderRadius of Card
                ),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0.1, 8, 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize:
                    MainAxisSize.min, // Set mainAxisSize to MainAxisSize.min
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 8, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 2, // Limit the number of lines to avoid overflow
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
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
