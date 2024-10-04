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

  PreferredSizeWidget _buildFeedHeader() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Styled by You'),
    );
  }

  Widget? _buildFeedFooter() {
    return Container(
      height: 60,
      color: Colors.black.withOpacity(0.6),
      alignment: Alignment.center,
      child: const Text(
        'Footer Placeholder',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RailWithFeed(
          publishId: publishId,
          onProductClick: onProductClick,
          header: _buildFeedHeader(),
          footer: _buildFeedFooter(),
        ),
      ),
    );
  }
}
