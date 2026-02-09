import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addProduct(Product product) {
    return _db.collection('products').add(product.toMap());
  }

  Future<void> deleteProduct(String id) {
    return _db.collection('products').doc(id).delete();
  }
}
