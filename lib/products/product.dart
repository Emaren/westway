class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String category;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      category: '',
    );
  }
}
