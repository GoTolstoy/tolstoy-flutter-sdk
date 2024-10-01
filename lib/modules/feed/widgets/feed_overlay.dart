import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

import 'feed_product_list.dart';

class FeedAssetOverlay extends StatelessWidget {
  final bool isPlaying;
  final bool isMuted;
  final List<Product> products;
  final VoidCallback onPlayPause;
  final VoidCallback onMuteUnmute;
  final void Function(Product)? onProductClick;

  const FeedAssetOverlay({
    super.key,
    required this.isPlaying,
    required this.isMuted,
    required this.products,
    required this.onPlayPause,
    required this.onMuteUnmute,
    this.onProductClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.transparent,
          ),
          if (!isPlaying)
            Center(
              child: GestureDetector(
                onTap: onPlayPause,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF222222).withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      size: 64,
                      color: Colors.white,
                    ),
                    onPressed: onPlayPause,
                  ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF222222).withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: onMuteUnmute,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (products.isNotEmpty)
                  FeedProductList(
                    products: products,
                    onProductClick: onProductClick,
                  ),
                if (products.isNotEmpty)
                  const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
