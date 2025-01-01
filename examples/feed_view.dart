import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/modules/feed/widgets/feed_view.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/batch_products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

const String publishId = "YOUR_PUBLISH_ID";

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  void _handleProductClick(Product product) {
    // Implement logic for product click
    debugInfo("Product clicked: ${product.title}");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Feed")),
        body: TvConfigProvider(
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
          builder: (context, config) {
            final localConfig = config;

            if (localConfig == null) {
              return const Center(
                child: SpinKitRing(
                  color: Colors.white,
                  size: 60,
                ),
              );
            }

            return FeedView(
              config: localConfig,
              options: const FeedViewOptions(
                isMutedByDefault: true,
                pageThreshold: 5,
              ),
              onProductClick: _handleProductClick,
              onVideoError: (message, asset) {
                // Implement logic for video error
                debugError("Video error: $message");
              },
            );
          },
        ),
      );
}
