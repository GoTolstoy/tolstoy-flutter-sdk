import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/constants.dart';
import 'package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart';

import 'image_asset.dart';
import 'video_asset.dart';

class AssetView extends StatefulWidget {
  const AssetView({
    super.key,
    required this.asset,
    required this.config,
    this.onAssetEnded,
    this.onProgressUpdate,
    this.options = const AssetViewOptions(),
  });

  final Asset asset;
  final TvPageConfig config;
  final AssetViewOptions options;
  final Function(Asset)? onAssetEnded;
  final Function(
    Asset asset,
    Duration progress,
    Duration duration,
  )? onProgressUpdate;

  @override
  State<AssetView> createState() => _AssetViewState();
}

class _AssetViewState extends State<AssetView> {
  @override
  Widget build(BuildContext context) {
    switch (widget.asset.type) {
      case AssetType.video:
        return VideoAsset(
          asset: widget.asset,
          config: widget.config,
          options: widget.options,
          onAssetEnded: widget.onAssetEnded,
          onProgressUpdate: widget.onProgressUpdate,
        );
      case AssetType.image:
        return ImageAsset(
          asset: widget.asset,
          options: widget.options,
          config: widget.config,
          onAssetEnded: widget.onAssetEnded,
          onProgressUpdate: widget.onProgressUpdate,
        );
    }
  }
}
