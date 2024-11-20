import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

import 'feed_product_list.dart';

class FeedAssetOverlay extends StatelessWidget {
  final bool isPlaying;
  final bool isMuted;
  final List<Product> products;
  final VoidCallback onPlayPause;
  final VoidCallback onMuteUnmute;
  final void Function(Product)? onProductClick;
  final Stream<double> progressStream;

  const FeedAssetOverlay({
    super.key,
    required this.isPlaying,
    required this.isMuted,
    required this.products,
    required this.onPlayPause,
    required this.onMuteUnmute,
    this.onProductClick,
    required this.progressStream,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: onPlayPause,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: !isPlaying
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222).withAlpha(204),
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
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF222222).withAlpha(204),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onPressed: onMuteUnmute,
                    ),
                  ),
                ],
              ),
            ),
          ]),
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
                        color: const Color(0xFF222222).withAlpha(204),
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
              if (products.isNotEmpty) const SizedBox(height: 12),
              StreamBuilder<double>(
                stream: progressStream,
                builder: (context, snapshot) {
                  return LinearProgressIndicator(
                    value: snapshot.data ?? 0.0,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFFF15B56)),
                    backgroundColor: Colors.grey,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
