import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/rail/widgets/rail.dart';
import 'package:tolstoy_flutter_sdk/modules/api/widgets/tv_config_provider.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/rail/models.dart';

const String publishId = 'YOUR_PUBLISH_ID';

class RailScreen extends StatelessWidget {
  const RailScreen({super.key});

  void _handleAssetClick(Asset asset) {
    // Implement logic for asset click
    print('Asset clicked: ${asset.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rail Example')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Featured Content',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TvConfigProvider(
            publishId: publishId,
            builder: (context, config) {
              return Rail(
                config: config,
                onAssetClick: _handleAssetClick,
                options: const RailOptions(
                  itemWidth: 160,
                  itemHeight: 240,
                  itemGap: 12,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
