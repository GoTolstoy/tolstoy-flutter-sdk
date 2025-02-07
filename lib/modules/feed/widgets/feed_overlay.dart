import "dart:async";

import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/modules/feed/widgets/feed_product_list.dart";
import "package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart";

class FeedAssetOverlay extends StatelessWidget {
  const FeedAssetOverlay({
    required this.isPlayingEnabled,
    required this.isMuted,
    required this.products,
    required this.onPlayPause,
    required this.onMuteUnmute,
    required this.progressStream,
    required this.asset,
    this.clientConfig = const TvPageClientConfig(),
    this.handle,
    super.key,
    this.onProductClick,
  });

  static const buttonBackgroundColor = Color(0xCC222222);
  static const iconColor = Colors.white;

  final bool isPlayingEnabled;
  final bool isMuted;
  final List<Product?> products;
  final VoidCallback onPlayPause;
  final VoidCallback onMuteUnmute;
  final void Function(Product)? onProductClick;
  final Stream<double> progressStream;
  final Asset asset;
  final TvPageClientConfig clientConfig;
  final String? handle;

  @override
  Widget build(BuildContext context) {
    final localHandle = handle;

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: onPlayPause,
          child: ColoredBox(
            color: Colors.transparent,
            child: Center(
              child: !isPlayingEnabled
                  ? IconButton(
                      // Use zero padding and IconButton.styleFrom instead of BoxDecoration
                      // to address the reported issue with misplaced circle background
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 80,
                        height: 80,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                        shape: const CircleBorder(),
                      ),
                      icon: const Icon(
                        Icons.play_arrow,
                        size: 64,
                        color: iconColor,
                      ),
                      onPressed: onPlayPause,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (localHandle != null)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: FeedAssetOverlay.buttonBackgroundColor,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Text(
                            "@$localHandle",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox.shrink(),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: buttonBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isMuted ? Icons.volume_off : Icons.volume_up,
                          color: iconColor,
                        ),
                        onPressed: onMuteUnmute,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (products.isNotEmpty)
                FeedProductList(
                  options: const FeedProductListOptions(
                    padding: EdgeInsets.zero,
                  ),
                  asset: asset,
                  clientConfig: clientConfig,
                  products: products,
                  onProductClick: onProductClick,
                ),
              if (products.isNotEmpty) const SizedBox(height: 36),
              StreamBuilder<double>(
                stream: progressStream,
                builder: (context, snapshot) => LinearProgressIndicator(
                  value: snapshot.data ?? 0.0,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFFF15B56)),
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
