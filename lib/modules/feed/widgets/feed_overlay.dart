import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

import 'feed_product_list.dart';

enum DotsMenuOption { report }

class FeedAssetOverlay extends StatelessWidget {
  static const buttonBackgroundColor = Color(0xCC222222);
  static const iconColor = Colors.white;
  static const menuBackgroundColor = Color.fromRGBO(9, 10, 25, 0.8);
  static const menuErrorColor = Color.fromARGB(255, 226, 80, 109);
  static const modalBackgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const modalErrorColor = Color.fromARGB(255, 226, 80, 109);

  final bool isPlayingEnabled;
  final bool isMuted;
  final List<Product> products;
  final VoidCallback onPlayPause;
  final VoidCallback onMuteUnmute;
  final void Function(Product)? onProductClick;
  final Stream<double> progressStream;

  const FeedAssetOverlay({
    super.key,
    required this.isPlayingEnabled,
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
              child: !isPlayingEnabled
                  ? Container(
                      decoration: BoxDecoration(
                        color: buttonBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 64,
                          color: iconColor,
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
                      color: buttonBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton<DotsMenuOption>(
                      color: menuBackgroundColor,
                      icon: Icon(Icons.more_vert),
                      iconColor: iconColor,
                      onSelected: (value) {
                        if (value == DotsMenuOption.report) {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: modalBackgroundColor,
                            builder: (BuildContext context) {
                              return Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 50, 20, 50),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.feedback_outlined,
                                              color: modalErrorColor,
                                              size: 32,
                                            ),
                                            const SizedBox(width: 20),
                                            const Text(
                                              'Report',
                                              style: TextStyle(
                                                color: modalErrorColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: modalErrorColor,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: DotsMenuOption.report,
                          child: Container(
                            constraints: BoxConstraints(minWidth: 150),
                            child: ListTile(
                              leading: Icon(Icons.report),
                              title: Text('Report'),
                              iconColor: menuErrorColor,
                              textColor: menuErrorColor,
                            ),
                          ),
                        ),
                      ],
                      offset: Offset(-55, -10),
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
