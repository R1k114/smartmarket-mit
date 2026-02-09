// lib/models/product.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String uid;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.uid,
    required this.createdAt,
  });

  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final ts = data['createdAt'];

    return Product(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : (data['price'] is double)
              ? data['price'] as double
              : double.tryParse((data['price'] ?? '0').toString()) ?? 0,
      uid: (data['uid'] ?? '').toString(),
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
