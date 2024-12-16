import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/assets/constants.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/widgets/assets/image_asset.dart";
import "package:tolstoy_flutter_sdk/modules/assets/widgets/assets/video_asset.dart";
import "package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart";

class AssetView extends StatefulWidget {
  const AssetView({
    required this.asset,
    required this.config,
    super.key,
    this.onAssetEnded,
    this.onProgressUpdate,
    this.options = const AssetViewOptions(),
    this.preload = true,
    this.onVideoError,
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
  final bool preload;
  final void Function(String message, Asset asset)? onVideoError;

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
          preload: widget.preload,
          onVideoError: widget.onVideoError,
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
