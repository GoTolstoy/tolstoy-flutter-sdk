import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/widgets.dart';

class RailAsset extends StatelessWidget {
  final Asset asset;
  final VoidCallback onTap;
  final VoidCallback onPlayClick;
  final double width;
  final double height;

  const RailAsset({
    super.key,
    required this.asset,
    required this.onTap,
    required this.onPlayClick,
    required this.width,
    required this.height,
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
                options: const AssetViewOptions(
                  imageFit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                child: GestureDetector(
                  onTap: onPlayClick,
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 18,
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
