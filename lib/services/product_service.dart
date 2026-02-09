import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final _collection = FirebaseFirestore.instance.collection('products');

  Stream<List<Product>> getProducts() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addProduct(String name, double price) {
    return _collection.add({
      'name': name,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProduct(String id) {
    return _collection.doc(id).delete();
  }
}
