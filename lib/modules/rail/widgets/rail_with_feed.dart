import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/feed/screens.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets/consts.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets/rail.dart";

class RailWithFeed extends StatelessWidget {
  RailWithFeed({
    required this.config,
    super.key,
    this.railOptions = const RailOptions(),
    this.onProductClick,
    this.buildFeedHeader,
    this.buildFeedFooter,
    this.onAssetClick,
    this.onVideoError,
  }) {
    final initialAssets = config.assets
        .sublist(0, config.assets.length.clamp(0, maxVisibleItems));
    config.preload(initialAssets);
  }

  final TvPageConfig config;
  final RailOptions railOptions;
  final void Function(Product)? onProductClick;
  final PreferredSizeWidget? Function({
    required BuildContext context,
    required TvPageConfig config,
    required void Function() openTolstoyMenu,
  })? buildFeedHeader;
  final Widget? Function({
    required BuildContext context,
    required TvPageConfig config,
  })? buildFeedFooter;
  final void Function(Asset)? onAssetClick;
  final void Function(String message, Asset asset)? onVideoError;

  @override
  Widget build(BuildContext context) => Rail(
        config: config,
        options: railOptions,
        onVideoError: onVideoError,
        onAssetClick: (Asset asset) {
          onAssetClick?.call(asset);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FeedScreen(
                config: config,
                initialAssetId: asset.id,
                onProductClick: onProductClick,
                buildFeedHeader: buildFeedHeader,
                buildFeedFooter: buildFeedFooter,
                onVideoError: onVideoError,
              ),
            ),
          );
        },
      );
}
