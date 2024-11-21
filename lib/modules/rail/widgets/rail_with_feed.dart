import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/rail/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/screens.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart';

import 'rail.dart';

class RailWithFeed extends StatelessWidget {
  final String publishId;
  final RailOptions railOptions;
  final void Function(Product)? onProductClick;
  final PreferredSizeWidget? Function({
    required BuildContext context,
    required TvPageConfig config,
    required void Function() openTolstoyMenu,
  })? buildFeedHeader;
  final Widget? Function({
    required BuildContext context,
    required TvPageConfig config,
  })? buildFeedFooter;

  const RailWithFeed({
    super.key,
    required this.publishId,
    this.railOptions = const RailOptions(),
    this.onProductClick,
    this.buildFeedHeader,
    this.buildFeedFooter,
  });

  @override
  Widget build(BuildContext context) {
    return TvConfigProvider(
      publishId: publishId,
      builder: (context, config) {
        return Rail(
          config: config,
          options: railOptions,
          onAssetClick: (Asset asset) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FeedScreen(
                  config: config,
                  initialAssetId: asset.id,
                  onProductClick: onProductClick,
                  buildFeedHeader: buildFeedHeader,
                  buildFeedFooter: buildFeedFooter,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
