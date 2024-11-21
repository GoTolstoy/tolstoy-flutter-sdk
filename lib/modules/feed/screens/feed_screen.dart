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
    this.buildFeedHeader,
    this.buildFeedFooter,
  });

  final TvPageConfig config;
  final void Function(Product)? onProductClick;
  final String? initialAssetId;
  final PreferredSizeWidget? Function(BuildContext)? buildFeedHeader;
  final Widget? Function(BuildContext)? buildFeedFooter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildFeedHeader?.call(context),
      body: FeedView(
        config: config,
        onProductClick: onProductClick,
        initialAssetId: initialAssetId,
        buildFeedFooter: buildFeedFooter,
        options: const FeedViewOptions(
          pageThreshold: 10,
          isMutedByDefault: true,
        ),
      ),
    );
  }
}
