import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartMarket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: productService.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          if (products.isEmpty) {
            return const Center(child: Text('Nema proizvoda'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('${product.price.toStringAsFixed(2)} RSD'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    productService.deleteProduct(product.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
      ),
    );
  }
}
