import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/batch_products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/rail/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets/rail.dart";
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

const String publishId = "YOUR_PUBLISH_ID";

class RailScreen extends StatelessWidget {
  const RailScreen({super.key});

  void _handleAssetClick(Asset asset) {
    // Implement logic for asset click
    debugInfo("Asset clicked: ${asset.id}");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Rail Example")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Featured Content",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TvConfigProvider(
              publishId: publishId,
              createProductsLoader: ({
                required String appKey,
                required String appUrl,
                required List<Asset> assets,
              }) =>
                  BatchProductsLoader(
                appKey: appKey,
                appUrl: appUrl,
                assets: assets,
              ),
              builder: (context, config) => Rail(
                config: config,
                onAssetClick: _handleAssetClick,
                onVideoError: (message, asset) {
                  // Implement logic for video error
                  debugError("Video error: $message");
                },
                options: const RailOptions(
                  itemWidth: 160,
                  itemHeight: 240,
                  itemGap: 12,
                ),
              ),
            ),
          ],
        ),
      );
}
