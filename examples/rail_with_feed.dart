import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models/asset.dart';
import 'package:tolstoy_flutter_sdk/modules/rail/widgets.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart';

const String publishId = 'YOUR_PUBLISH_ID';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _onProductClick(Product product) {
    // Implement logic for product click
    // ignore: avoid_print
    print('product clicked: ${product.title}');
  }

  void _onAssetClick(Asset asset) {
    // Implement logic for asset click
    // ignore: avoid_print
    print('asset clicked: ${asset.name}');
  }

  PreferredSizeWidget? _buildFeedHeader({
    required BuildContext context,
    required TvPageConfig config,
    required void Function() openTolstoyMenu,
  }) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Styled by You'),
    );
  }

  Widget? _buildFeedFooter({
    required BuildContext context,
    required TvPageConfig config,
  }) {
    return Container(
      height: 60,
      color: Colors.black.withOpacity(0.6),
      alignment: Alignment.center,
      child: const Text(
        'Footer Placeholder',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TvConfigProvider(
          publishId: publishId,
          builder: (context, config) {
            return RailWithFeed(
              config: config,
              onProductClick: _onProductClick,
              buildFeedHeader: _buildFeedHeader,
              buildFeedFooter: _buildFeedFooter,
              onAssetClick: _onAssetClick,
              onVideoError: (message, asset) {
                // Implement logic for video error
                // ignore: avoid_print
                print('Video error: $message');
              },
            );
          },
        ),
      ),
    );
  }
}
