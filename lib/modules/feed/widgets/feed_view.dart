import "dart:convert";
import "dart:math";

import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/analytics/analytics.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/constants.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/feed/widgets/feed_asset.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";

class FeedViewOptions {
  const FeedViewOptions({
    this.isMutedByDefault = false,
    this.isAutoplay = true,
    this.pageThreshold = 10,
    this.isLoadingNextPage = false,
  });

  final bool isMutedByDefault;
  final bool isAutoplay;

  final int pageThreshold;
  final bool isLoadingNextPage;
}

class FeedView extends StatefulWidget {
  FeedView({
    required this.config,
    this.clientConfig = const TvPageClientConfig(),
    this.safeInsets = EdgeInsets.zero,
    super.key,
    this.onLoadNextPage,
    this.options = const FeedViewOptions(),
    this.onProductClick,
    this.initialAssetId,
    this.onAssetIdChange,
    this.buildFeedFooter,
    this.onVideoError,
  }) : footerKey = GlobalKey();

  final TvPageConfig config;
  final TvPageClientConfig clientConfig;
  final FeedViewOptions options;
  final Function()? onLoadNextPage;
  final void Function(Product)? onProductClick;
  final String? initialAssetId;
  final void Function(String assetId)? onAssetIdChange;
  final Widget? Function({
    required BuildContext context,
    required TvPageConfig config,
  })? buildFeedFooter;
  final GlobalKey footerKey;
  final VideoErrorCallback? onVideoError;
  final EdgeInsets safeInsets;

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView>
    with AutomaticKeepAliveClientMixin {
  late PageController _pageViewController;
  bool isPlayingEnabled = true;
  bool isMuted = false;
  int activePageIndex = 0;
  late FocusNode _focusNode;
  bool _isVisible = true;
  late Analytics _analytics;
  double _footerHeight = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _analytics = Analytics(onError: widget.config.onError);
    _analytics.sendSessionStart(widget.config);

    isPlayingEnabled = widget.options.isAutoplay;
    isMuted = widget.options.isMutedByDefault;

    var initialPage = 0;
    if (widget.initialAssetId != null) {
      initialPage = widget.config.assets
          .indexWhere((asset) => asset.id == widget.initialAssetId);
      initialPage = initialPage != -1 ? initialPage : 0;
    }

    _pageViewController = PageController(initialPage: initialPage);
    activePageIndex = initialPage;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _calculateFooterHeight();
    });
  }

  void _calculateFooterHeight() {
    if (widget.buildFeedFooter != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final footerBox = widget.footerKey.currentContext?.findRenderObject();

        if (footerBox is RenderBox) {
          setState(() {
            _footerHeight = footerBox.size.height;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isVisible = _focusNode.hasFocus;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      activePageIndex = index;
      widget.onAssetIdChange?.call(widget.config.assets[index].id);
    });
  }

  void _onPlayClick(Asset asset) {
    setState(() {
      isPlayingEnabled = !isPlayingEnabled;
    });
  }

  void _onMuteClick(Asset asset) {
    setState(() {
      isMuted = !isMuted;
    });
  }

  void _onProductClick(Product product) {
    _analytics.sendProductClicked(widget.config, {
      "products": jsonEncode(product.toJson()),
      "productIds": jsonEncode([product.id]),
      "productNames": product.title,
    });
    widget.onProductClick?.call(product);
  }

  Widget? itemBuilder(BuildContext context, int index) {
    if (index > widget.config.assets.length - 1) {
      return null;
    }

    final isActive = activePageIndex == index;
    final int threshold =
        min(widget.config.assets.length, widget.options.pageThreshold);

    if (isActive &&
        activePageIndex == widget.config.assets.length - threshold &&
        !widget.options.isLoadingNextPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLoadNextPage?.call();
      });
    }

    final asset = widget.config.assets[index];

    return KeepAliveWrapper(
      child: FutureBuilder<List<Product>>(
        future: widget.config.getProducts(asset),
        builder: (context, snapshot) {
          final products = snapshot.data ?? List<Product?>.filled(1, null);

          return FeedAssetView(
            asset: asset,
            config: widget.config,
            clientConfig: widget.clientConfig,
            options: AssetViewOptions(
              isPlaying: isPlayingEnabled && isActive && _isVisible,
              isPlayingEnabled: isPlayingEnabled,
              isMuted: isMuted,
              shouldLoop: true,
              withMuteButton: asset.type != AssetType.image,
              trackAnalytics: true,
            ),
            onPlayClick: _onPlayClick,
            onMuteClick: _onMuteClick,
            products: products,
            onProductClick: _onProductClick,
            onVideoError: widget.onVideoError,
            feedAssetOptions: FeedAssetOptions(
              overlayBottomPadding: _footerHeight + widget.safeInsets.bottom,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final footer = widget.buildFeedFooter?.call(
      context: context,
      config: widget.config,
    );

    return Focus(
      focusNode: _focusNode,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              scrollDirection: Axis.vertical,
              itemBuilder: itemBuilder,
              onPageChanged: _onPageChanged,
              allowImplicitScrolling: true,
            ),
            if (activePageIndex == widget.config.assets.length - 1 &&
                widget.options.isLoadingNextPage)
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(),
              ),
            if (footer != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: KeyedSubtree(
                  key: widget.footerKey,
                  child: footer,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({required this.child, super.key});
  final Widget child;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
