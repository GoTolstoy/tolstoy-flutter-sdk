import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/feed/screens.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets/rail.dart";

class RailWithFeed extends StatefulWidget {
  const RailWithFeed({
    required this.config,
    this.clientConfig = const TvPageClientConfig(),
    this.safeInsets = EdgeInsets.zero,
    super.key,
    this.railOptions = const RailOptions(),
    this.onProductClick,
    this.buildFeedHeader,
    this.buildFeedFooter,
    this.onAssetClick,
    this.onVideoError,
    this.showMoreButton = true,
    this.maxVisibleItems = 6,
  });

  final TvPageConfig? config;
  final TvPageClientConfig clientConfig;
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
  final VideoErrorCallback? onVideoError;
  final EdgeInsets safeInsets;
  final bool showMoreButton;
  final int maxVisibleItems;
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
        clientConfig: widget.clientConfig,
        showMoreButton: widget.showMoreButton,
        maxVisibleItems: widget.maxVisibleItems,
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
                  clientConfig: widget.clientConfig,
                  initialAssetId: asset.id,
                  onProductClick: widget.onProductClick,
                  buildFeedHeader: widget.buildFeedHeader,
                  buildFeedFooter: widget.buildFeedFooter,
                  onVideoError: widget.onVideoError,
                  safeInsets: widget.safeInsets,
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
        .sublist(0, localConfig.assets.length.clamp(0, widget.maxVisibleItems));
    localConfig.preload(initialAssets);
  }
}
