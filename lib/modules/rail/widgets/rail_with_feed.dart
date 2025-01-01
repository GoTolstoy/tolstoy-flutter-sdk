import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/feed/screens.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets/consts.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets/rail.dart";

class RailWithFeed extends StatefulWidget {
  const RailWithFeed({
    required this.config,
    super.key,
    this.railOptions = const RailOptions(),
    this.onProductClick,
    this.buildFeedHeader,
    this.buildFeedFooter,
    this.onAssetClick,
    this.onVideoError,
  });

  final TvPageConfig? config;
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
  State<RailWithFeed> createState() => _RailWithFeedState();
}

class _RailWithFeedState extends State<RailWithFeed> {
  @override
  void initState() {
    super.initState();
    _preloadAssets();
  }

  @override
  void didUpdateWidget(RailWithFeed oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.config != oldWidget.config) {
      _preloadAssets();
    }
  }

  @override
  Widget build(BuildContext context) => Rail(
        config: widget.config,
        options: widget.railOptions,
        onVideoError: widget.onVideoError,
        onAssetClick: (Asset asset) {
          widget.onAssetClick?.call(asset);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                final localConfig = widget.config;

                if (localConfig == null) {
                  return Scaffold(
                    body: Container(
                      color: Colors.red,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  );
                }

                return FeedScreen(
                  config: localConfig,
                  initialAssetId: asset.id,
                  onProductClick: widget.onProductClick,
                  buildFeedHeader: widget.buildFeedHeader,
                  buildFeedFooter: widget.buildFeedFooter,
                  onVideoError: widget.onVideoError,
                );
              },
            ),
          );
        },
      );

  void _preloadAssets() {
    final localConfig = widget.config;

    if (localConfig == null) {
      return;
    }

    final initialAssets = localConfig.assets
        .sublist(0, localConfig.assets.length.clamp(0, maxVisibleItems));
    localConfig.preload(initialAssets);
  }
}
