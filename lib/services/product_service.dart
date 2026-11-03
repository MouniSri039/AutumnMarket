
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductService {
  final CollectionReference<Map<String, dynamic>> _products =
      FirebaseFirestore.instance.collection('products');

  // CREATE: Add a product with an automatically generated document ID.
  Future<String> addProduct({
    required String name,
    required double price,
  }) async {
    final docRef = await _products.add({
      'name': name.trim(),
      'price': price,
    });

    return docRef.id;
  }

  // READ: Listen to real-time changes in the products collection.
  Stream<List<Product>> streamProducts() {
    return _products.snapshots().map((snapshot) {
      return snapshot.docs
          .map((document) => Product.fromFirestore(document))
          .toList();
    });
  }

  // UPDATE: Update a product using its document ID.
  Future<void> updateProduct({
    required String id,
    required String name,
    required double price,
  }) async {
    await _products.doc(id).update({
      'name': name.trim(),
      'price': price,
    });
  }

  // DELETE: Delete a product using its document ID.
  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }
}
