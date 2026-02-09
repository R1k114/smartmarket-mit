import 'package:flutter/material.dart';
import '../core/app_routes.dart';

class GuestScreen extends StatelessWidget {
  const GuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartMarket'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            child: const Text('Login'),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Gost režim ✅\n(ovde ide javni prikaz sadržaja)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
