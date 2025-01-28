import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/analytics/analytics.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/models.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets/rail_asset.dart";
import "package:tolstoy_flutter_sdk/modules/rail/widgets/rail_more_asset.dart";
import "package:visibility_detector/visibility_detector.dart";

class Rail extends StatefulWidget {
  const Rail({
    required this.config,
    super.key,
    this.clientConfig = const TvPageClientConfig(),
    this.onAssetClick,
    this.options = const RailOptions(),
    this.onVideoError,
    this.showMoreButton = true,
    this.maxVisibleItems = 6,
  });

  final TvPageConfig? config;
  final TvPageClientConfig clientConfig;
  final void Function(Asset)? onAssetClick;
  final RailOptions options;
  final VideoErrorCallback? onVideoError;
  final bool showMoreButton;
  final int maxVisibleItems;

  @override
  State<Rail> createState() => _RailState();
}

class _RailState extends State<Rail> {
  Analytics? _analytics;
  bool _isVisible = false;
  bool _hasBeenVisible = false;
  int _currentPlayingIndex = 0;
  bool _currentVideoEnded = false;
  late final ScrollController _scrollController;
  final _visibilityKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeAnalytics();
  }

  @override
  void didUpdateWidget(Rail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config) {
      _initializeAnalytics();
    }
  }

  void _initializeAnalytics() {
    final localConfig = widget.config;

    if (localConfig == null) {
      return;
    }

    _analytics = Analytics(onError: localConfig.onError);
    _analytics?.sendPageView(localConfig);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get visibleItemCount =>
      widget.config?.assets.length.clamp(0, widget.maxVisibleItems) ??
      widget.maxVisibleItems;

  double get railWidth =>
      context.size?.width ?? MediaQuery.of(context).size.width;

  double get itemScrollStep =>
      widget.options.itemWidth + widget.options.itemGap;

  double get totalContentWidth =>
      itemScrollStep * visibleItemCount -
      widget.options.itemGap +
      2 * widget.options.xPadding;

  double get maxScrollOffset => totalContentWidth - railWidth;

  bool _shouldPreload(int index) =>
      index == _currentPlayingIndex || index == _currentPlayingIndex + 1;

  bool __isVideoFullyInView(int index) {
    final currentScrollOffset = _scrollController.position.pixels;

    final itemStartOffset = widget.options.xPadding + index * itemScrollStep;
    final itemEndOffset = itemStartOffset + widget.options.itemWidth;

    return itemStartOffset >= currentScrollOffset &&
        itemEndOffset <= currentScrollOffset + railWidth;
  }

  int? _getFirstVideoFullyInView() {
    for (var i = 0; i < visibleItemCount; i++) {
      if (__isVideoFullyInView(i)) {
        return i;
      }
    }

    return null;
  }

  void _onCurrentVideoEnded() {
    if (!mounted) {
      return;
    }

    final nextIndex = _currentPlayingIndex + 1;

    if (nextIndex < visibleItemCount && __isVideoFullyInView(nextIndex)) {
      setState(() {
        _currentPlayingIndex = nextIndex;
        _currentVideoEnded = false;
      });
    } else {
      setState(() {
        _currentVideoEnded = true;
      });
    }
  }

  void _onScrollEnd() {
    final currentVideoInView = __isVideoFullyInView(_currentPlayingIndex);

    // if current video is still in view and playing, continue playing
    if (currentVideoInView && !_currentVideoEnded) {
      return;
    }

    // if current video is still in view and has ended, try to play next video
    if (currentVideoInView && _currentVideoEnded) {
      final nextIndex = _currentPlayingIndex + 1;

      if (nextIndex < visibleItemCount && __isVideoFullyInView(nextIndex)) {
        setState(() {
          _currentPlayingIndex = nextIndex;
          _currentVideoEnded = false;
        });

        return;
      }
    }

    final firstVideoInView = _getFirstVideoFullyInView();

    if (firstVideoInView != null) {
      setState(() {
        _currentPlayingIndex = firstVideoInView;
        _currentVideoEnded = false;
      });
    }
  }

  void _scrollToCurrentVideo() {
    if (_scrollController.hasClients) {
      final targetOffset = widget.options.xPadding +
          _currentPlayingIndex * itemScrollStep -
          0.5 * (railWidth - widget.options.itemWidth);

      _scrollController.animateTo(
        targetOffset.clamp(0.0, maxScrollOffset),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _playVideo(int index) {
    setState(() {
      _currentPlayingIndex = index;
      _currentVideoEnded = false;
    });

    _scrollToCurrentVideo();
  }

  @override
  Widget build(BuildContext context) {
    final localConfig = widget.config;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          _onScrollEnd();
        }

        return true;
      },
      child: VisibilityDetector(
        key: _visibilityKey,
        onVisibilityChanged: (visibilityInfo) {
          if (!mounted) {
            return;
          }

          if (visibilityInfo.visibleFraction > 0.5 && !_hasBeenVisible) {
            _hasBeenVisible = true;
            if (localConfig != null) {
              _analytics?.sendEmbedView(localConfig);
            }
          }

          setState(() {
            _isVisible = visibilityInfo.visibleFraction > 0.5;
          });
        },
        child: SizedBox(
          height: widget.options.itemHeight,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: visibleItemCount,
            itemBuilder: (context, index) {
              final asset = localConfig?.assets[index];
              final isFirstItem = index == 0;
              final isLastItem = index == visibleItemCount - 1;

              return Padding(
                padding: EdgeInsets.only(
                  left: isFirstItem
                      ? widget.options.xPadding
                      : widget.options.itemGap / 2,
                  right: isLastItem
                      ? widget.options.xPadding
                      : widget.options.itemGap / 2,
                ),
                child: isLastItem && widget.showMoreButton
                    ? RailMoreAsset(
                        config: localConfig,
                        clientConfig: widget.clientConfig,
                        onTap: () {
                          if (localConfig == null || asset == null) {
                            return;
                          }

                          widget.onAssetClick?.call(asset);
                        },
                        width: widget.options.itemWidth,
                        height: widget.options.itemHeight,
                      )
                    : RailAsset(
                        asset: asset,
                        config: localConfig,
                        clientConfig: widget.clientConfig,
                        onTap: () {
                          if (localConfig == null || asset == null) {
                            return;
                          }

                          widget.onAssetClick?.call(asset);
                          _analytics?.sendVideoClicked(
                            localConfig,
                            {"videoId": asset.id},
                          );
                        },
                        onPlayClick: () {
                          if (localConfig == null || asset == null) {
                            return;
                          }

                          _playVideo(index);
                          _analytics?.sendVideoWatched(
                            localConfig,
                            {"videoId": asset.id},
                          );
                        },
                        onVideoEnded: (asset) {
                          if (index != _currentPlayingIndex) {
                            return;
                          }

                          _onCurrentVideoEnded();
                        },
                        onVideoError: widget.onVideoError,
                        width: widget.options.itemWidth,
                        height: widget.options.itemHeight,
                        options: AssetViewOptions(
                          isPlaying: index == _currentPlayingIndex &&
                              _isVisible &&
                              !_currentVideoEnded,
                          isMuted: true,
                          imageFit: BoxFit.cover,
                          playMode: AssetViewOptionsPlayMode.preview,
                        ),
                        preload: _shouldPreload(index),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
