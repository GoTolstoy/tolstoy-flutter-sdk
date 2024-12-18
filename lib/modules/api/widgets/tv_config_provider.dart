import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_config.dart";
import "package:tolstoy_flutter_sdk/modules/api/services.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";

class TvConfigProvider extends StatefulWidget {
  const TvConfigProvider({
    required this.builder,
    required this.publishId,
    required this.createProductsLoader,
    this.disableCache = false,
    super.key,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
  });

  final Widget Function(BuildContext, TvPageConfig) builder;
  final String publishId;
  final ProductsLoaderFactory createProductsLoader;
  final bool disableCache;
  final Widget loadingWidget;

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
    final config = await ApiService.getTvPageConfig(
      widget.publishId,
      widget.createProductsLoader,
      disableCache: widget.disableCache,
    );

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
