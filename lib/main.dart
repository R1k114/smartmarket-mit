import 'package:flutter/material.dart';

void main() {
  runApp(const SmartMarketApp());
}

class SmartMarketApp extends StatelessWidget {
  const SmartMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'SmartMarket',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
