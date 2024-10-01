import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/constants.dart';

import 'feed_asset.dart';

class FeedViewOptions {
  final bool isMutedByDefault;
  final bool isAutoplay;

  final int pageThreshold;
  final bool isLoadingNextPage;

  const FeedViewOptions({
    this.isMutedByDefault = false,
    this.isAutoplay = true,
    this.pageThreshold = 10,
    this.isLoadingNextPage = false,
  });
}

class FeedView extends StatefulWidget {
  const FeedView({
    super.key,
    required this.config,
    this.onLoadNextPage,
    this.options = const FeedViewOptions(),
    this.onProductClick,
    this.initialAssetId,
  });

  final TvPageConfig config;
  final FeedViewOptions options;
  final Function()? onLoadNextPage;
  final void Function(Product)? onProductClick;
  final String? initialAssetId;

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late PageController _pageViewController;
  bool isPlaying = true;
  bool isMuted = false;
  int activePageIndex = 0;
  late FocusNode _focusNode;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    isPlaying = widget.options.isAutoplay;
    isMuted = widget.options.isMutedByDefault;
    
    int initialPage = 0;
    if (widget.initialAssetId != null) {
      initialPage = widget.config.assets.indexWhere((asset) => asset.id == widget.initialAssetId);
      initialPage = initialPage != -1 ? initialPage : 0;
    }
    
    _pageViewController = PageController(initialPage: initialPage);
    activePageIndex = initialPage;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isVisible = _focusNode.hasFocus;
        isPlaying = _isVisible && widget.options.isAutoplay;
      });
    }
  }

  _onPageChanged(int index) {
    setState(() {
      activePageIndex = index;
    });
  }

  void _onPlayClick(Asset asset) {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _onMuteClick(Asset asset) {
    setState(() {
      isMuted = !isMuted;
    });
  }

  Widget? itemBuilder(BuildContext context, int index) {
    if (index > widget.config.assets.length - 1) {
      return null;
    }

    bool isActive = activePageIndex == index;
    int threshold = min(widget.config.assets.length, widget.options.pageThreshold);

    if (isActive && activePageIndex == widget.config.assets.length - threshold && !widget.options.isLoadingNextPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLoadNextPage?.call();
      });
    }

    Asset asset = widget.config.assets[index];

    // Compile list of products from productsMap
    List<Product> products = asset.products
        .map((productRef) => widget.config.productsMap.getProductById(productRef.id))
        .where((product) => product != null)
        .cast<Product>()
        .toList();

    return FeedAssetView(
      asset: asset,
      options: AssetViewOptions(
        isPlaying: isPlaying && isActive,
        isMuted: isMuted,
        shouldLoop: true,
        withMuteButton: asset.type != AssetType.image,
      ),
      onPlayClick: _onPlayClick,
      onMuteClick: _onMuteClick,
      products: products,
      onProductClick: widget.onProductClick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: Container(
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
            if (activePageIndex == widget.config.assets.length - 1 && widget.options.isLoadingNextPage)
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}