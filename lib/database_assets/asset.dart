class Asset {
  final String category;
  final String type;
  final String unitNumber;
  // final String age;
  final String currentLocation;
  final String? imageUrl;

  Asset({
    required this.category,
    required this.type,
    required this.unitNumber,
    // required this.age,
    required this.currentLocation,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'type': type,
      'imageUrl': imageUrl,
      'unitNumber': unitNumber,
      'currentLocation': currentLocation,
      // 'age': age,
    };
  }

  static Asset fromMap(Map<String, dynamic> map, String docId) {
    return Asset(
      category: map['category'],
      type: map['type'],
      imageUrl: map['imageUrl'],
      unitNumber: docId,
      currentLocation: map['currentLocation'],
      // age: map['age'],
    );
  }
}
