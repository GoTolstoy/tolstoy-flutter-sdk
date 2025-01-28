import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/batch_products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets.dart";
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

const String appKey = "YOUR_APP_KEY";
const String publishId = "YOUR_PUBLISH_ID";

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _onProductClick(Product product) {
    // Implement logic for product click
    debugInfo("product clicked: ${product.title}");
  }

  void _onAssetClick(Asset asset) {
    // Implement logic for asset click
    debugInfo("asset clicked: ${asset.name}");
  }

  PreferredSizeWidget? _buildFeedHeader({
    required BuildContext context,
    required TvPageConfig config,
    required void Function() openTolstoyMenu,
  }) =>
      AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Styled by You"),
      );

  Widget? _buildFeedFooter({
    required BuildContext context,
    required TvPageConfig config,
  }) =>
      Container(
        height: 60,
        color: Colors.black.withOpacity(0.6),
        alignment: Alignment.center,
        child: const Text(
          "Footer Placeholder",
          style: TextStyle(fontSize: 16),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: TvConfigProvider(
            appKey: appKey,
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
            builder: (context, config) => RailWithFeed(
              config: config,
              onProductClick: _onProductClick,
              buildFeedHeader: _buildFeedHeader,
              buildFeedFooter: _buildFeedFooter,
              onAssetClick: _onAssetClick,
              onVideoError: (message, asset, playMode) {
                // Implement logic for video error
                debugInfo("Video error: $message");
                return null;
              },
            ),
          ),
        ),
      );
}
