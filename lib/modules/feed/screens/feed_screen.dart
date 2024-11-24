import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/feed_view.dart';
import 'package:tolstoy_flutter_sdk/modules/api/services/api.dart';
import 'feed_screen_menu.dart';
import 'dart:convert';

class FeedScreen extends StatefulWidget {
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
          showModalBottomSheet(
            context: context,
            backgroundColor: _modalBackgroundColor,
            builder: (BuildContext context) => FeedScreenMenu(
                onReport: ({required String id, required String title}) async =>
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
                        'timestamp': DateTime.now().toUtc().toIso8601String(),
                        'videoId': _currentAssetId,
                      }),
                    }),
            isScrollControlled: true,
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
