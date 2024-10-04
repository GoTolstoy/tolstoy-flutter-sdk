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

  void _playNextVideo() {
    setState(() {
      _currentPlayingIndex = (_currentPlayingIndex + 1) % widget.config.assets.length.clamp(0, maxVisibleItems);
    });
    _scrollToCurrentVideo();
  }

  void _scrollToCurrentVideo() {
    if (_scrollController.hasClients) {
      final railWidth = context.size?.width ?? MediaQuery.of(context).size.width;
      final itemWidth = widget.options.itemWidth + widget.options.itemGap;
      final visibleItemCount = widget.config.assets.length.clamp(0, maxVisibleItems);
      final remainingItems = (visibleItemCount + 1) - _currentPlayingIndex;
      final remainingWidth = remainingItems * itemWidth;

      if (remainingWidth > railWidth) {
        final targetOffset = _currentPlayingIndex * itemWidth;
        final maxOffset = (visibleItemCount * itemWidth) - railWidth - widget.options.itemGap;
        final clampedOffset = targetOffset.clamp(0.0, maxOffset);

        _scrollController.animateTo(
          clampedOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  bool _shouldPreload(int index) {
    final visibleItemCount = widget.config.assets.length.clamp(0, maxVisibleItems);
    if (_currentPlayingIndex == 0) {
      // if first playing: preload first and second items
      return index == 0 || index == 1;
    } else if (_currentPlayingIndex == visibleItemCount - 1) {
      // if last playing: second last items, preload last and first items
      return index == visibleItemCount - 2 || index == visibleItemCount - 1 || index == 0;
    } else {
      // if non edge item playing: preload current and adjacent items
      return index >= _currentPlayingIndex - 1 && index <= _currentPlayingIndex + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('rail-${widget.config.publishId}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5 && !_hasBeenVisible) {
          _hasBeenVisible = true;
          _analytics.sendEmbedView(widget.config);
        }
      },
      child: SizedBox(
        height: widget.options.itemHeight,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.config.assets.length.clamp(0, maxVisibleItems),
          separatorBuilder: (context, index) => SizedBox(width: widget.options.itemGap),
          itemBuilder: (context, index) {
            final asset = widget.config.assets[index];
            return RailAsset(
              asset: asset,
              config: widget.config,
              onTap: () {
                widget.onAssetClick?.call(asset);
                _analytics.sendVideoClicked(widget.config, { 'videoId': asset.id });
              },
              onPlayClick: () {
                widget.onPlayClick?.call(asset);
                _analytics.sendVideoWatched(widget.config, { 'videoId': asset.id });
              },
              onVideoEnded: (asset) {
                _playNextVideo();
              },
              width: widget.options.itemWidth,
              height: widget.options.itemHeight,
              options: AssetViewOptions(
                isPlaying: index == _currentPlayingIndex,
                isMuted: true,
                shouldLoop: false,
                imageFit: BoxFit.cover,
              ),
              preload: _shouldPreload(index),
            );
          },
        ),
      ),
    );
  }
}
