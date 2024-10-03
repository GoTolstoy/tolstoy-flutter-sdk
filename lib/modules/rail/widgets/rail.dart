import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/rail/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/analytics/analytics.dart';

import 'rail_asset.dart';

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

  @override
  void initState() {
    super.initState();
    _analytics = Analytics();
    _analytics.sendPageView(widget.config);
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
          scrollDirection: Axis.horizontal,
          itemCount: widget.config.assets.length.clamp(0, 6),
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
              width: widget.options.itemWidth,
              height: widget.options.itemHeight,
              options: AssetViewOptions(
                isPlaying: index == 0, // playing first only for now
                isMuted: true,
                shouldLoop: true,
                imageFit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
