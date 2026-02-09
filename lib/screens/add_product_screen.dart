import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: '',
      name: _nameCtrl.text.trim(),
      price: double.parse(_priceCtrl.text),
    );

    await ProductService().addProduct(product);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj proizvod')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Naziv'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Unesi naziv' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cena'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Unesi cenu';
                  if (double.tryParse(v) == null) return 'Neispravan broj';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Sačuvaj'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
