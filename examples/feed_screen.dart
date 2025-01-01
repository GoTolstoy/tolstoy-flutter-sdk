import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/modules/feed/screens/feed_screen.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/batch_products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

const String publishId = "YOUR_PUBLISH_ID";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Tolstoy Feed Example"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FeedPage(),
                ),
              );
            },
            child: const Text("Open Feed"),
          ),
        ),
      );
}

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) => TvConfigProvider(
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

          return FeedScreen(
            config: localConfig,
            onProductClick: (Product product) {
              // Implement logic for product click
              debugInfo("Product clicked: ${product.title}");
            },
          );
        },
      );
}
