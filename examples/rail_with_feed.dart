import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/rail/widgets.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

const String publishId = 'YOUR_PUBLISH_ID';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void onProductClick(Product product) {
    print('product clicked: ${product.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RailWithFeed(
          publishId: publishId,
          onProductClick: onProductClick,
        ),
      ),
    );
  }
}
