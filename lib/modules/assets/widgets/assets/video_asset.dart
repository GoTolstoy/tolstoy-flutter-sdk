import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/services.dart';
import 'package:tolstoy_flutter_sdk/modules/analytics/analytics.dart';

const watchThresholdMS = 200;

class VideoAsset extends StatefulWidget {
  const VideoAsset({
    super.key,
    required this.asset,
    required this.config,
    this.onAssetEnded,
    this.onProgressUpdate,
    this.options = const AssetViewOptions(),
    this.preload = true,
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
  final bool preload;

  @override
  State<VideoAsset> createState() => _VideoAssetState();
}

class _VideoAssetState extends State<VideoAsset> {
  VideoPlayerController? _controller;
  late String _thumbnailUrl;
  late Analytics _analytics;
  int _loopCount = 0;
  bool _hasPlayed = false;
  bool _hasWatched = false;
  Duration _lastPosition = Duration.zero;
  bool _isVideoInitialized = false;
  bool _isVideoReady = false;

  @override
  void initState() {
    super.initState();
    _analytics = Analytics();

    _thumbnailUrl = AssetService.getPosterUrl(widget.asset);

    if (widget.preload) {
      _initializeVideoController();
    }
  }

  void _initializeVideoController() {
    final url = widget.options.playMode == AssetViewOptionsPlayMode.preview
        ? AssetService.getPreviewUrl(widget.asset)
        : AssetService.getAssetUrl(widget.asset);

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    )..initialize().then((_) {
        _isVideoInitialized = true;
        _controller!.setLooping(widget.options.shouldLoop);
        _updateControllerState();
        _controller!.addListener(_videoPlayerListener);
        setState(() {});
        // Add a small delay before setting _isVideoReady to true
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            setState(() {
              _isVideoReady = true;
            });
          }
        });
      });
  }

  void _videoPlayerListener() {
    final currentPosition = _controller!.value.position;

    if (currentPosition >= _controller!.value.duration) {
      if (!_controller!.value.isLooping) {
        _controller!.seekTo(Duration.zero);
      }

      if (widget.onAssetEnded != null) {
        widget.onAssetEnded!(widget.asset);
      }
    }

    if (!_controller!.value.isPlaying) {
      _sendVideoWatchedAnalytics();
      return;
    }

    _hasWatched = true;

    if (!_hasPlayed && widget.options.trackAnalytics) {
      _analytics.sendVideoLoaded(
        widget.config,
        {
          'videoId': widget.asset.id,
          'text': widget.asset.name,
          'type': widget.asset.type.name,
        },
      );
      _hasPlayed = true;
    }

    if (_lastPosition > currentPosition &&
        _lastPosition.inMilliseconds > watchThresholdMS) {
      _loopCount++;
    }

    _lastPosition = currentPosition;

    if (_controller!.value.isPlaying &&
        widget.onProgressUpdate != null &&
        currentPosition > Duration.zero) {
      widget.onProgressUpdate!(
          widget.asset, currentPosition, _controller!.value.duration);
    }
  }

  void _sendVideoWatchedAnalytics() {
    if (!_hasWatched || !widget.options.trackAnalytics) {
      return;
    }

    final watchedSeconds = _controller!.value.position.inMicroseconds /
            1000000.0 +
        (_loopCount * _controller!.value.duration.inMicroseconds / 1000000.0);

    if (watchedSeconds == 0.0) {
      return;
    }

    _analytics.sendVideoWatched(
      widget.config,
      {
        'videoId': widget.asset.id,
        'text': widget.asset.name,
        'type': widget.asset.type.name,
        'videoLoopCount': _loopCount,
        'videoWatchedTime': watchedSeconds,
        'videoDuration': _controller!.value.duration.inMicroseconds / 1000000.0,
      },
    );
    _loopCount = 0;
    _hasWatched = false;
  }

  void _updateControllerState() {
    if (_controller == null) return;
    setState(() {
      if (widget.options.isPlaying) {
        _controller!.play();
      } else {
        _controller!.pause();
      }
      _controller!.setVolume(widget.options.isMuted ? 0.0 : 1.0);
    });
  }

  @override
  void didUpdateWidget(VideoAsset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preload != widget.preload &&
        widget.preload &&
        _controller == null) {
      _initializeVideoController();
    }
    if (_controller != null &&
        (oldWidget.options.isPlaying != widget.options.isPlaying ||
            oldWidget.options.isMuted != widget.options.isMuted)) {
      _updateControllerState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          _thumbnailUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: CircularProgressIndicator());
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
        if (_controller != null && _isVideoInitialized)
          AnimatedOpacity(
            opacity: _isVideoReady ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _controller!.value.size.height,
                width: _controller!.value.size.width,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _sendVideoWatchedAnalytics();
    _controller?.removeListener(_videoPlayerListener);
    _controller?.dispose();
    super.dispose();
  }
}
