import "dart:ui";
import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_config.dart";
import "package:tolstoy_flutter_sdk/modules/api/services.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

class TvConfigProvider extends StatefulWidget {
  const TvConfigProvider({
    required this.builder,
    required this.publishId,
    required this.createProductsLoader,
    this.disableCache = false,
    this.onError,
    super.key,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
  });

  final Widget Function(BuildContext, TvPageConfig) builder;
  final String publishId;
  final ProductsLoaderFactory createProductsLoader;
  final bool disableCache;
  final ErrorCallback? onError;
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
      onError: widget.onError,
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

    try {
      return widget.builder(context, localConfig);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugError(e);
      localConfig.onError?.call(e, StackTrace.current);
      return widget.loadingWidget;
    }
  }
}
