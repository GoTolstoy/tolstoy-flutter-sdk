import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/rail/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';

import 'rail_asset.dart';

class Rail extends StatelessWidget {
  final TvPageConfig config;
  final Function(Asset)? onAssetClick;
  final Function(Asset)? onPlayClick;
  final RailOptions options;

  const Rail({
    super.key,
    required this.config,
    this.onAssetClick,
    this.onPlayClick,
    this.options = const RailOptions(),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: options.itemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: config.assets.length,
        separatorBuilder: (context, index) => SizedBox(width: options.itemGap),
        itemBuilder: (context, index) {
          final asset = config.assets[index];
          return RailAsset(
            asset: asset,
            onTap: () => onAssetClick?.call(asset),
            onPlayClick: () => onPlayClick?.call(asset),
            width: options.itemWidth,
            height: options.itemHeight,
          );
        },
      ),
    );
  }
}
