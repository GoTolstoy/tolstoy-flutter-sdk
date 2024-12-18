import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_config.dart";

class PreloadedTvConfigProvider extends StatefulWidget {
  const PreloadedTvConfigProvider({
    required this.builder,
    required this.config,
    super.key,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
  });

  final Widget Function(BuildContext, TvPageConfig) builder;
  final Future<TvPageConfig> config;
  final Widget loadingWidget;

  @override
  State<PreloadedTvConfigProvider> createState() =>
      _PreloadedTvConfigProviderState();
}

class _PreloadedTvConfigProviderState extends State<PreloadedTvConfigProvider> {
  TvPageConfig? _config;

  @override
  void initState() {
    super.initState();
    _fetchConfig();
  }

  Future<void> _fetchConfig() async {
    final config = await widget.config;

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
