import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/widgets.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'feed_overlay.dart';
import 'dart:async';

class FeedAssetOptions {
  final double overlayBottomPadding;

  const FeedAssetOptions({
    this.overlayBottomPadding = 0.0,
  });
}

class FeedAssetView extends StatefulWidget {
  const FeedAssetView({
    super.key,
    required this.asset,
    required this.config,
    required this.onPlayClick,
    required this.onMuteClick,
    this.options = const AssetViewOptions(),
    required this.products,
    this.onProductClick,
    this.preload = true,
    this.feedAssetOptions = const FeedAssetOptions(),
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

  @override
  State<FeedAssetView> createState() => _FeedAssetViewState();
}

class _FeedAssetViewState extends State<FeedAssetView> {
  final StreamController<double> _progressStreamController =
      StreamController<double>.broadcast();

  void _handleProgressUpdate(
      Asset asset, Duration progress, Duration duration) {
    _progressStreamController
        .add(progress.inMilliseconds / duration.inMilliseconds);
  }

  @override
  void dispose() {
    _progressStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AssetView(
          asset: widget.asset,
          config: widget.config,
          options: widget.options,
          preload: widget.preload,
          onProgressUpdate: _handleProgressUpdate,
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: widget.feedAssetOptions?.overlayBottomPadding ?? 0,
          child: FeedAssetOverlay(
            products: widget.products,
            isPlaying: widget.options.isPlaying,
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
}
