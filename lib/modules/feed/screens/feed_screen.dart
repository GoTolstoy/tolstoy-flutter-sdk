import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/feed_view.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({
    super.key,
    required this.config,
    this.onProductClick,
    this.title = 'Styled by You',
  });

  final TvPageConfig config;
  final void Function(Product)? onProductClick;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title),
      ),
      body: FeedView(
        config: config,
        onProductClick: onProductClick,
        options: const FeedViewOptions(
          pageThreshold: 10,
          isMutedByDefault: true, // temp
        ),
      ),
    );
  }
}
