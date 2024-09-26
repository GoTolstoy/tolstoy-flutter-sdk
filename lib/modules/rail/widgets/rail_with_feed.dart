import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/rail/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/screens.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart';

import 'rail.dart';

class RailWithFeed extends StatelessWidget {
  final String publishId;
  final RailOptions railOptions;
  final void Function(Product)? onProductClick;

  const RailWithFeed({
    super.key,
    required this.publishId,
    this.railOptions = const RailOptions(),
    this.onProductClick,
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
                  onProductClick: onProductClick,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
