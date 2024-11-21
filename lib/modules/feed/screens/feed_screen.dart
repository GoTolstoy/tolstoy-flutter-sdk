import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/feed_view.dart';

class FeedScreen extends StatelessWidget {
  static const modalBackgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const modalErrorColor = Color.fromARGB(255, 226, 80, 109);

  const FeedScreen({
    super.key,
    required this.config,
    this.onProductClick,
    this.initialAssetId,
    this.buildFeedHeader,
    this.buildFeedFooter,
  });

  final TvPageConfig config;
  final void Function(Product)? onProductClick;
  final String? initialAssetId;
  final PreferredSizeWidget? Function({
    required BuildContext context,
    required TvPageConfig config,
    required void Function() openTolstoyMenu,
  })? buildFeedHeader;
  final Widget? Function({
    required BuildContext context,
    required TvPageConfig config,
  })? buildFeedFooter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildFeedHeader?.call(
        context: context,
        config: config,
        openTolstoyMenu: () => {
          showModalBottomSheet(
            context: context,
            backgroundColor: modalBackgroundColor,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        },
      ),
      body: FeedView(
        config: config,
        onProductClick: onProductClick,
        initialAssetId: initialAssetId,
        buildFeedFooter: buildFeedFooter,
        options: const FeedViewOptions(
          pageThreshold: 10,
          isMutedByDefault: true,
        ),
      ),
    );
  }
}
