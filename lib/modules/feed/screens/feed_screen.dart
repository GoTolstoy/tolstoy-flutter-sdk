import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/feed_view.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({
    super.key,
    required this.config,
    this.onProductClick,
    this.initialAssetId,
    this.header,
    this.footer,
  });

  final TvPageConfig config;
  final void Function(Product)? onProductClick;
  final String? initialAssetId;
  final PreferredSizeWidget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header,
      body: FeedView(
        config: config,
        onProductClick: onProductClick,
        initialAssetId: initialAssetId,
        footer: footer,
        options: const FeedViewOptions(
          pageThreshold: 10,
          isMutedByDefault: true,
        ),
      ),
    );
  }
}
