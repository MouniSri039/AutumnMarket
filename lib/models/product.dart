
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });

  // Convert a Firestore document into a Product object.
  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return Product(
      id: document.id,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
    );
  }

  // Convert a Product object into Firestore-compatible data.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
    };
  }
}
