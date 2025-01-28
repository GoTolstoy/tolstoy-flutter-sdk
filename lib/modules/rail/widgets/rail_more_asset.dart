import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";

class RailMoreAsset extends StatelessWidget {
  const RailMoreAsset({
    required this.onTap,
    required this.config,
    required this.width,
    required this.height,
    this.clientConfig = const TvPageClientConfig(),
    super.key,
  });

  final VoidCallback onTap;
  final TvPageConfig? config;
  final TvPageClientConfig clientConfig;
  final double width;
  final double height;

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
              children: [
                if (config != null)
                  clientConfig.placeholderWidget
                else
                  clientConfig.loadingPlaceholderWidget,
                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("See more", style: TextStyle(fontSize: 15)),
                      SizedBox(width: 4),
                      Icon(Icons.east, size: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
