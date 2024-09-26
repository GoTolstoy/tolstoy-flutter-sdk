import 'dart:math';
import 'package:flutter/material.dart';

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
  });

  final TvPageConfig config;
  final FeedViewOptions options;
  final Function()? onLoadNextPage;
  final void Function(Product)? onProductClick;

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late PageController _pageViewController;
  bool isPlaying = true;
  bool isMuted = false;
  int activePageIndex = 0;

  @override
  void initState() {
    super.initState();
    isPlaying = widget.options.isAutoplay;
    isMuted = widget.options.isMutedByDefault;
    _pageViewController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
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
    return Container(
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
    );
  }
}
