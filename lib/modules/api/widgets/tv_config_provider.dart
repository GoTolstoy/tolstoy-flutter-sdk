import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_config.dart";
import "package:tolstoy_flutter_sdk/modules/api/services.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";

class TvConfigProvider extends StatefulWidget {
  const TvConfigProvider({
    required this.publishId,
    required this.builder,
    required this.createProductsLoader,
    super.key,
    this.config,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
  });
  final String publishId;
  final Future<TvPageConfig>? config;
  final Widget Function(BuildContext, TvPageConfig) builder;
  final Widget loadingWidget;
  final ProductsLoader Function({
    required String appKey,
    required String appUrl,
    required List<Asset> assets,
  }) createProductsLoader;

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

  Future<void> _fetchConfig() async {
    final config = await (widget.config ??
        ApiService.getTvPageConfig(
          widget.publishId,
          widget.createProductsLoader,
        ));

    if (mounted) {
      setState(() {
        _config = config;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localConfig = _config;

    if (localConfig == null) {
      return widget.loadingWidget;
    }

    return widget.builder(context, localConfig);
  }
}
