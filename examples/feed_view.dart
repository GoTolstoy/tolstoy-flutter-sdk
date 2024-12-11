import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/feed_view.dart';
import 'package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

const String publishId = 'YOUR_PUBLISH_ID';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  void _handleProductClick(Product product) {
    // Implement logic for product click
    // ignore: avoid_print
    print('Product clicked: ${product.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: TvConfigProvider(
        publishId: publishId,
        builder: (context, config) {
          return FeedView(
            config: config,
            options: const FeedViewOptions(
              isMutedByDefault: true,
              isAutoplay: true,
              pageThreshold: 5,
            ),
            onProductClick: _handleProductClick,
          );
        },
      ),
    );
  }
}
