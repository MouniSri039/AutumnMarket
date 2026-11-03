
import 'package:flutter_test/flutter_test.dart';
import 'package:autumn_market/models/product.dart';

void main() {
  group('Product model tests', () {
    test('Product stores its fields correctly', () {
      const product = Product(
        id: 'test123',
        name: 'Cedar Mug',
        price: 12.50,
      );

      expect(product.id, 'test123');
      expect(product.name, 'Cedar Mug');
      expect(product.price, 12.50);
    });

    test('Product converts to Firestore-compatible data', () {
      const product = Product(
        id: 'test123',
        name: 'Cedar Mug',
        price: 12.50,
      );

      final data = product.toFirestore();

      expect(data['name'], 'Cedar Mug');
      expect(data['price'], 12.50);
      expect(data['price'], isA<double>());
      expect(data.containsKey('id'), false);
    });
  });
}
