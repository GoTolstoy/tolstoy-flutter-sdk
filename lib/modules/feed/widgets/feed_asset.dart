import "dart:async";
import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/widgets.dart";
import "package:tolstoy_flutter_sdk/modules/feed/widgets/feed_overlay.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";

class FeedAssetOptions {
  const FeedAssetOptions({
    this.overlayBottomPadding = 0.0,
  });
  final double overlayBottomPadding;
}

class FeedAssetView extends StatefulWidget {
  const FeedAssetView({
    required this.asset,
    required this.config,
    required this.onPlayClick,
    required this.onMuteClick,
    required this.products,
    super.key,
    this.options = const AssetViewOptions(),
    this.onProductClick,
    this.preload = true,
    this.feedAssetOptions = const FeedAssetOptions(),
    this.onVideoError,
  });

  final Asset asset;
  final TvPageConfig config;
  final AssetViewOptions options;
  final List<Product> products;
  final Function(Asset) onPlayClick;
  final Function(Asset) onMuteClick;
  final void Function(Product)? onProductClick;
  final bool preload;
  final FeedAssetOptions? feedAssetOptions;
  final void Function(String message, Asset asset)? onVideoError;

  @override
  State<FeedAssetView> createState() => _FeedAssetViewState();
}

class _FeedAssetViewState extends State<FeedAssetView> {
  final StreamController<double> _progressStreamController =
      StreamController<double>.broadcast();

  void _handleProgressUpdate(
    Asset asset,
    Duration progress,
    Duration duration,
  ) {
    _progressStreamController
        .add(progress.inMilliseconds / duration.inMilliseconds);
  }

  @override
  void dispose() {
    _progressStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          AssetView(
            asset: widget.asset,
            config: widget.config,
            options: widget.options,
            preload: widget.preload,
            onProgressUpdate: _handleProgressUpdate,
            onVideoError: widget.onVideoError,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: widget.feedAssetOptions?.overlayBottomPadding ?? 0,
            child: FeedAssetOverlay(
              products: widget.products,
              isPlayingEnabled: widget.options.isPlayingEnabled,
              isMuted: widget.options.isMuted,
              onProductClick: widget.onProductClick,
              onPlayPause: () => widget.onPlayClick(widget.asset),
              onMuteUnmute: () => widget.onMuteClick(widget.asset),
              progressStream: _progressStreamController.stream,
            ),
          ),
        ],
      );
}
