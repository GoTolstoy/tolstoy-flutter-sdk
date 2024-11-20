import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/rail/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/analytics/analytics.dart';

import 'rail_asset.dart';

const maxVisibleItems = 6;

class Rail extends StatefulWidget {
  final TvPageConfig config;
  final Function(Asset)? onAssetClick;
  final Function(Asset)? onPlayClick;
  final RailOptions options;

  const Rail({
    super.key,
    required this.config,
    this.onAssetClick,
    this.onPlayClick,
    this.options = const RailOptions(),
  });

  @override
  State<Rail> createState() => _RailState();
}

class _RailState extends State<Rail> {
  late final Analytics _analytics;
  bool _hasBeenVisible = false;
  int _currentPlayingIndex = 0;
  bool _currentVideoEnded = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _analytics = Analytics();
    _analytics.sendPageView(widget.config);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get visibleItemCount {
    return widget.config.assets.length.clamp(0, maxVisibleItems);
  }

  bool _shouldPreload(int index) {
    if (_currentPlayingIndex == 0) {
      // if first playing: preload first and second items
      return index == 0 || index == 1;
    } else if (_currentPlayingIndex == visibleItemCount - 1) {
      // if last playing: second last items, preload last and first items
      return index == visibleItemCount - 2 ||
          index == visibleItemCount - 1 ||
          index == 0;
    } else {
      // if non edge item playing: preload current and adjacent items
      return index >= _currentPlayingIndex - 1 &&
          index <= _currentPlayingIndex + 1;
    }
  }

  bool __isVideoFullyInView(int index) {
    final railWidth = context.size?.width ?? MediaQuery.of(context).size.width;
    final itemWidth = widget.options.itemWidth + widget.options.itemGap;
    final currentScrollOffset = _scrollController.position.pixels;

    final itemStartOffset = index * itemWidth;
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
    final nextIndex = _currentPlayingIndex + 1;

    if (nextIndex < visibleItemCount && __isVideoFullyInView(nextIndex)) {
      setState(() {
        _currentPlayingIndex = nextIndex;
        _currentVideoEnded = false;
      });
    } else {
      _currentVideoEnded = true;
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

    // Play first video in view
    final firstVideoInView = _getFirstVideoFullyInView();

    if (firstVideoInView != null) {
      setState(() {
        _currentPlayingIndex = firstVideoInView;
        _currentVideoEnded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          _onScrollEnd();
        }

        return true;
      },
      child: VisibilityDetector(
        key: Key('rail-${widget.config.publishId}'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction > 0.5 && !_hasBeenVisible) {
            _hasBeenVisible = true;
            _analytics.sendEmbedView(widget.config);
          }
        },
        child: SizedBox(
          height: widget.options.itemHeight,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: visibleItemCount,
            itemBuilder: (context, index) {
              final asset = widget.config.assets[index];
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
                child: RailAsset(
                  asset: asset,
                  config: widget.config,
                  onTap: () {
                    widget.onAssetClick?.call(asset);
                    _analytics
                        .sendVideoClicked(widget.config, {'videoId': asset.id});
                  },
                  onPlayClick: () {
                    widget.onPlayClick?.call(asset);
                    _analytics
                        .sendVideoWatched(widget.config, {'videoId': asset.id});
                  },
                  onVideoEnded: (asset) {
                    if (index != _currentPlayingIndex) {
                      return;
                    }

                    _onCurrentVideoEnded();
                  },
                  width: widget.options.itemWidth,
                  height: widget.options.itemHeight,
                  options: AssetViewOptions(
                    isPlaying: index == _currentPlayingIndex,
                    isMuted: true,
                    shouldLoop: false,
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
