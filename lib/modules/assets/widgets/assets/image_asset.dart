import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/analytics/analytics.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/services.dart";

class ImageAsset extends StatefulWidget {
  const ImageAsset({
    required this.asset,
    required this.config,
    super.key,
    this.onAssetEnded,
    this.onProgressUpdate,
    this.options = const AssetViewOptions(),
  });

  final Asset asset;
  final TvPageConfig config;
  final Function(Asset)? onAssetEnded;
  final Function(
    Asset asset,
    Duration progress,
    Duration duration,
  )? onProgressUpdate;
  final AssetViewOptions options;

  @override
  State<ImageAsset> createState() => _ImageAssetState();
}

class _ImageAssetState extends State<ImageAsset> {
  Duration _progressTime = Duration.zero;
  late Analytics _analytics;
  int _loopCount = 0;
  bool _hasPlayed = false;
  bool _hasWatched = false;

  @override
  void initState() {
    super.initState();
    _analytics = Analytics();
    if (widget.options.isPlaying) {
      _startPlaying();
    }
  }

  void _assetEnded() {
    _progressTime = Duration.zero;

    if (widget.options.shouldLoop) {
      _progressTime = Duration.zero;
      _loopCount++;
      return;
    }

    widget.onAssetEnded?.call(widget.asset);
  }

  void _sendImageViewedAnalytics() {
    if (!widget.options.trackAnalytics || !_hasWatched) {
      return;
    }

    final watchedSeconds = _progressTime.inMicroseconds / 1000000.0 +
        (_loopCount * widget.options.imagePlaytimeSec / 1000000.0);

    if (watchedSeconds == 0.0) {
      return;
    }

    _analytics.sendVideoWatched(
      widget.config,
      {
        "videoId": widget.asset.id,
        "text": widget.asset.name,
        "type": widget.asset.type.name,
        "videoLoopCount": _loopCount,
        "videoWatchedTime": watchedSeconds,
        "videoDuration": widget.options.imagePlaytimeSec,
      },
    );
    _loopCount = 0;
    _hasWatched = false;
  }

  void _startPlaying() {
    const Duration tick = Duration(milliseconds: 100);
    final Duration duration =
        Duration(seconds: widget.options.imagePlaytimeSec);

    Future.delayed(tick, () {
      if (!widget.options.isPlaying) {
        _sendImageViewedAnalytics();
        return;
      }

      _hasWatched = true;

      if (!_hasPlayed && widget.options.trackAnalytics) {
        _analytics.sendVideoLoaded(
          widget.config,
          {
            "videoId": widget.asset.id,
            "text": widget.asset.name,
            "type": widget.asset.type.name,
          },
        );
        _hasPlayed = true;
      }

      _progressTime += tick;

      widget.onProgressUpdate?.call(widget.asset, _progressTime, duration);

      if (_progressTime >= duration) {
        _assetEnded();
      }

      _startPlaying();
    });
  }

  @override
  void didUpdateWidget(ImageAsset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options.isPlaying != widget.options.isPlaying) {
      if (widget.options.isPlaying) {
        _startPlaying();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Image.network(
          AssetService.getAssetUrl(widget.asset),
          fit: widget.options.imageFit,
          width: double.infinity,
          height: double.infinity,
        ),
      );

  @override
  void dispose() {
    if (_progressTime > Duration.zero) {
      _sendImageViewedAnalytics();
    }
    super.dispose();
  }
}
