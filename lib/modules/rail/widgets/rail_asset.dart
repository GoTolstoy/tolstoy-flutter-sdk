import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/widgets.dart';

class RailAsset extends StatelessWidget {
  final Asset asset;
  final TvPageConfig config;
  final AssetViewOptions? options;
  final VoidCallback onTap;
  final VoidCallback onPlayClick;
  final Function(Asset)? onVideoEnded;
  final double width;
  final double height;
  final bool preload;
  final void Function(String message, Asset asset)? onVideoError;

  const RailAsset({
    super.key,
    required this.asset,
    this.options,
    required this.config,
    required this.onTap,
    required this.onPlayClick,
    required this.onVideoEnded,
    required this.width,
    required this.height,
    this.preload = true,
    this.onVideoError,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                onAssetEnded: onVideoEnded,
                options:
                    options ?? const AssetViewOptions(imageFit: BoxFit.cover),
                preload: preload,
                onVideoError: onVideoError,
              ),
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
}
