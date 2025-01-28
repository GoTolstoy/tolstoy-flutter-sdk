import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/constants.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/widgets/assets/image_asset.dart";
import "package:tolstoy_flutter_sdk/modules/assets/widgets/assets/video_asset.dart";
import "package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart";

class AssetView extends StatefulWidget {
  const AssetView({
    required this.asset,
    required this.config,
    this.clientConfig = const TvPageClientConfig(),
    super.key,
    this.onAssetEnded,
    this.onProgressUpdate,
    this.options = const AssetViewOptions(),
    this.preload = true,
    this.onVideoError,
  });

  final Asset? asset;
  final TvPageConfig? config;
  final TvPageClientConfig clientConfig;
  final AssetViewOptions options;
  final Function(Asset)? onAssetEnded;
  final Function(
    Asset asset,
    Duration progress,
    Duration duration,
  )? onProgressUpdate;
  final bool preload;
  final VideoErrorCallback? onVideoError;

  @override
  State<AssetView> createState() => _AssetViewState();
}

class _AssetViewState extends State<AssetView> {
  @override
  Widget build(BuildContext context) {
    final localAsset = widget.asset;
    final localConfig = widget.config;

    return Stack(
      children: [
        widget.clientConfig.loadingPlaceholderWidget,
        if (localConfig != null &&
            localAsset != null &&
            localAsset.type == AssetType.video)
          VideoAsset(
            asset: localAsset,
            config: localConfig,
            clientConfig: widget.clientConfig,
            options: widget.options,
            onAssetEnded: widget.onAssetEnded,
            onProgressUpdate: widget.onProgressUpdate,
            preload: widget.preload,
            onVideoError: widget.onVideoError,
          ),
        if (localConfig != null &&
            localAsset != null &&
            localAsset.type == AssetType.image)
          ImageAsset(
            asset: localAsset,
            config: localConfig,
            options: widget.options,
            onAssetEnded: widget.onAssetEnded,
            onProgressUpdate: widget.onProgressUpdate,
          ),
      ],
    );
  }
}
