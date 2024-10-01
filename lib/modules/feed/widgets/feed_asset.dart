import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/widgets.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

import 'feed_overlay.dart';

class FeedAssetView extends StatefulWidget {
  const FeedAssetView({
    super.key,
    required this.asset,
    required this.onPlayClick,
    required this.onMuteClick,
    this.options = const AssetViewOptions(),
    required this.products,
    this.onProductClick,
  });

  final Asset asset;
  final AssetViewOptions options;
  final List<Product> products;
  final Function(Asset) onPlayClick;
  final Function(Asset) onMuteClick;
  final void Function(Product)? onProductClick;

  @override
  State<FeedAssetView> createState() => _FeedAssetViewState();
}

class _FeedAssetViewState extends State<FeedAssetView> {
  final ValueNotifier<double> _progressNotifier = ValueNotifier(0.0);

  void _handleProgressUpdate(Asset asset, Duration progress, Duration duration) {
    _progressNotifier.value = progress.inMilliseconds / duration.inMilliseconds;
  }

  @override
  void dispose() {
    _progressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: AssetView(
            asset: widget.asset,
            options: widget.options,
            onProgressUpdate: _handleProgressUpdate,
          ),
        ),
        FeedAssetOverlay(
          products: widget.products,
          isPlaying: widget.options.isPlaying,
          isMuted: widget.options.isMuted,
          onProductClick: widget.onProductClick,
          onPlayPause: () => widget.onPlayClick(widget.asset),
          onMuteUnmute: () => widget.onMuteClick(widget.asset),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ValueListenableBuilder<double>(
            valueListenable: _progressNotifier,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF15B56)),
                backgroundColor: Colors.transparent,
              );
            },
          ),
        ),
      ],
    );
  }
}
