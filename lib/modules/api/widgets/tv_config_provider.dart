import 'package:flutter/material.dart';
import 'package:tolstoy_flutter_sdk/modules/api/models/tv_page_config.dart';
import 'package:tolstoy_flutter_sdk/modules/api/services.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models/asset.dart';
import 'package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart';

class TvConfigProvider extends StatefulWidget {
  final String publishId;
  final Future<TvPageConfig>? config;
  final Widget Function(BuildContext, TvPageConfig) builder;
  final Widget loadingWidget;
  final ProductsLoader Function({
    required String appKey,
    required String appUrl,
    required List<Asset> assets,
  }) buildProductsLoader;

  const TvConfigProvider({
    super.key,
    required this.publishId,
    this.config,
    required this.builder,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
    required this.buildProductsLoader,
  });

  @override
  State<TvConfigProvider> createState() => _TvConfigProviderState();
}

class _TvConfigProviderState extends State<TvConfigProvider> {
  TvPageConfig? _config;

  @override
  void initState() {
    super.initState();
    _fetchConfig();
  }

  _fetchConfig() async {
    TvPageConfig config = await (widget.config ??
        ApiService.getTvPageConfig(
          widget.publishId,
          widget.buildProductsLoader,
        ));
    if (mounted) {
      setState(() {
        _config = config;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_config == null) {
      return widget.loadingWidget;
    }

    return widget.builder(context, _config!);
  }
}
