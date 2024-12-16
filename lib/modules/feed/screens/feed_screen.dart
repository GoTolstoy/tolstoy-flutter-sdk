import "dart:convert";
import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/api/services/api.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/modules/feed/screens/feed_screen_menu.dart";
import "package:tolstoy_flutter_sdk/modules/feed/widgets/feed_view.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    required this.config,
    super.key,
    this.onProductClick,
    this.initialAssetId,
    this.buildFeedHeader,
    this.buildFeedFooter,
    this.onVideoError,
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
  final void Function(String message, Asset asset)? onVideoError;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static const _modalBackgroundColor = Color.fromRGBO(255, 255, 255, 1);

  late String? _currentAssetId = widget.initialAssetId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: widget.buildFeedHeader?.call(
          context: context,
          config: widget.config,
          openTolstoyMenu: () {
            final safeArea = MediaQueryData.fromView(View.of(context)).padding;

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        16 + safeArea.left,
                        16 + safeArea.top,
                        16 + safeArea.right,
                        16 + safeArea.bottom,
                      ),
                      decoration: const BoxDecoration(
                        color: _modalBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: FeedScreenMenu(
                          onReport: ({
                            required String id,
                            required String title,
                          }) async =>
                              ApiService.sendEvent({
                            "accountId": widget.config.owner,
                            "appKey": widget.config.appKey,
                            "appUrl": widget.config.appUrl,
                            "contentReport": {"key": id, "description": title},
                            "eventName": "feedReportSubmit",
                            "formData": jsonEncode({
                              "key": id,
                              "description": title,
                            }),
                            "isMobile": true,
                            "playerType": "flutter",
                            "playlist": widget.config.name,
                            "projectId": widget.config.id,
                            "publishId": widget.config.publishId,
                            "stepName": widget.config.startStep,
                            "timestamp":
                                DateTime.now().toUtc().toIso8601String(),
                            "videoId": _currentAssetId,
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        body: FeedView(
          config: widget.config,
          onProductClick: widget.onProductClick,
          initialAssetId: widget.initialAssetId,
          onAssetIdChange: (assetId) =>
              setState(() => _currentAssetId = assetId),
          onVideoError: widget.onVideoError,
          buildFeedFooter: widget.buildFeedFooter,
          options: const FeedViewOptions(
            isMutedByDefault: true,
          ),
        ),
      );
}
