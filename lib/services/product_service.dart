import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Stream<List<Product>> streamMyProducts() {
    return _db
        .collection('products')
        .where('uid', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Product.fromDoc(d)).toList());
  }

  Future<void> addProduct({
    required String name,
    required double price,
  }) async {
    final product = Product(
      id: '',
      name: name,
      price: price,
      uid: _uid,
    );

    await _db.collection('products').add(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }
}
