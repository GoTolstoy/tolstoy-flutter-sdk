import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/feed_view.dart';
import 'package:tolstoy_flutter_sdk/modules/api/services/api.dart';
import 'feed_screen_menu.dart';
import 'dart:convert';

class FeedScreen extends StatefulWidget {
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
  final bool hideReportButton;
  final bool hideShareButton;
  final String? customMenuTitle;
  final String? customMenuSubtitle;
  final String? customMenuLogoUrl;

  const FeedScreen({
    super.key,
    required this.config,
    this.onProductClick,
    this.initialAssetId,
    this.buildFeedHeader,
    this.buildFeedFooter,
    this.hideReportButton = false,
    this.hideShareButton = false,
    this.customMenuTitle,
    this.customMenuSubtitle,
    this.customMenuLogoUrl,
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static const _modalBackgroundColor = Color.fromRGBO(255, 255, 255, 1);

  late String? _currentAssetId = widget.initialAssetId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.buildFeedHeader?.call(
        context: context,
        config: widget.config,
        openTolstoyMenu: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pop(context),
              child: Material(
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: _modalBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      child: FeedScreenMenu(
                        onReport: ({
                          required String id,
                          required String title,
                        }) async =>
                            {
                          await ApiService.sendEvent({
                            'accountId': widget.config.owner,
                            'appKey': widget.config.appKey,
                            'appUrl': widget.config.appUrl,
                            'contentReport': {'key': id, 'description': title},
                            'eventName': 'feedReportSubmit',
                            'formData': jsonEncode({
                              'key': id,
                              'description': title,
                            }),
                            'isMobile': true,
                            'playerType': 'flutter',
                            'playlist': widget.config.name,
                            'projectId': widget.config.id,
                            'publishId': widget.config.publishId,
                            'stepName': widget.config.startStep,
                            'timestamp':
                                DateTime.now().toUtc().toIso8601String(),
                            'videoId': _currentAssetId,
                          }),
                        },
                        hideReportButton: widget.hideReportButton,
                        hideShareButton: widget.hideShareButton,
                        customMenuTitle: widget.customMenuTitle,
                        customMenuSubtitle: widget.customMenuSubtitle,
                        customMenuLogoUrl: widget.customMenuLogoUrl,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        },
      ),
      body: FeedView(
        config: widget.config,
        onProductClick: widget.onProductClick,
        initialAssetId: widget.initialAssetId,
        onAssetIdChange: (assetId) => setState(() => _currentAssetId = assetId),
        buildFeedFooter: widget.buildFeedFooter,
        options: const FeedViewOptions(
          pageThreshold: 10,
          isMutedByDefault: true,
        ),
      ),
    );
  }
}
