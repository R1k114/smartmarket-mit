// lib/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('products');

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Nisi ulogovan');
    return u.uid;
  }

  Future<void> addProduct(String name, double price) async {
    await _col.add({
      'name': name,
      'price': price,
      'uid': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Product>> getProducts() {
    final uid = _uid;
    return _col
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Product.fromDoc).toList());
  }

  Future<void> updateProduct(String id, String name, double price) async {
    await _col.doc(id).update({
      'name': name,
      'price': price,
    });
  }

  Future<void> deleteProduct(String id) async {
    await _col.doc(id).delete();
  }
}
