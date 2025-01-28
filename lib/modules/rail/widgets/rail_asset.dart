import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/widgets.dart";
import "package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart";

class RailAsset extends StatelessWidget {
  const RailAsset({
    required this.asset,
    required this.config,
    required this.onTap,
    required this.onPlayClick,
    required this.onVideoEnded,
    required this.width,
    required this.height,
    this.clientConfig = const TvPageClientConfig(),
    super.key,
    this.options,
    this.preload = true,
    this.onVideoError,
  });

  final Asset? asset;
  final TvPageConfig? config;
  final TvPageClientConfig clientConfig;
  final AssetViewOptions? options;
  final VoidCallback onTap;
  final VoidCallback onPlayClick;
  final Function(Asset)? onVideoEnded;
  final double width;
  final double height;
  final bool preload;
  final VideoErrorCallback? onVideoError;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AssetView(
                  asset: asset,
                  config: config,
                  clientConfig: clientConfig,
                  onAssetEnded: onVideoEnded,
                  options:
                      options ?? const AssetViewOptions(imageFit: BoxFit.cover),
                  preload: preload,
                  onVideoError: onVideoError,
                ),
                if (config != null && asset != null)
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: GestureDetector(
                      onTap: onPlayClick,
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
