import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'product.dart';

class Cart extends ChangeNotifier {
  final String uid;
  List<Product> products = [];

  void add(Product product) {
    print('Display $uid');
    products.add(product);
    print('Display $uid');

    notifyListeners();
    print('Display $uid');

    FirebaseFirestore.instance.collection('carts').doc(uid).set({
      'products': products.map((product) => product.toMap()).toList(),
    });
    print('Display $uid');
  }

  void remove(Product product) {
    print('Display $uid');

    products.remove(product);
    notifyListeners();
    FirebaseFirestore.instance.collection('carts').doc(uid).set({
      'products': products.map((product) => product.toMap()).toList(),
    });
  }

  Cart(this.uid) {
    loadFromFirestore();
  }

  Future<void> loadFromFirestore() async {
    var doc =
        await FirebaseFirestore.instance.collection('carts').doc(uid).get();
    if (doc.exists) {
      products = (doc['products'] as List)
          .map((product) => Product.fromMap(product))
          .toList();
      notifyListeners();
    }
  }

  double get totalPrice {
    double total = 0.0;
    for (var product in products) {
      total += product.price;
    }
    return total;
  }

  int get itemCount {
    return products.length;
  }
}
