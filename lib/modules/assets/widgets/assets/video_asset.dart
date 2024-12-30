import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/analytics/analytics.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/services.dart";
import "package:video_player/video_player.dart";

const watchThresholdMS = 200;

class VideoAsset extends StatefulWidget {
  const VideoAsset({
    required this.asset,
    required this.config,
    super.key,
    this.onAssetEnded,
    this.onProgressUpdate,
    this.options = const AssetViewOptions(),
    this.preload = true,
    this.onVideoError,
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
  final void Function(String message, Asset asset)? onVideoError;

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
  VideoPlayerValue? _videoPlayerValue;

  @override
  void initState() {
    super.initState();
    _analytics = Analytics(onError: widget.config.onError);

    _thumbnailUrl = AssetService.getPosterUrl(widget.asset);

    if (widget.preload) {
      _initializeVideoController();
    }
  }

  void _initializeVideoController() {
    final url = widget.options.playMode == AssetViewOptionsPlayMode.preview
        ? AssetService.getPreviewUrl(widget.asset)
        : AssetService.getAssetUrl(widget.asset);

    final localController = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );

    _controller = localController;

    localController.addListener(_videoPlayerErrorListener);

    localController.initialize().then((_) {
      _isVideoInitialized = true;
      localController.setLooping(widget.options.shouldLoop);
      _updateControllerState();
      localController.addListener(_videoPlayerListener);
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

  void _videoPlayerErrorListener() {
    final localController = _controller;

    if (localController == null) {
      return;
    }

    setState(() {
      _videoPlayerValue = localController.value;
    });

    if (localController.value.hasError) {
      widget.onVideoError?.call(
        localController.value.errorDescription ?? "Unknown error",
        widget.asset,
      );
    }
  }

  void _videoPlayerListener() {
    final localController = _controller;

    if (localController == null) {
      return;
    }

    setState(() {
      _videoPlayerValue = localController.value;
    });

    final currentPosition = localController.value.position;

    if (currentPosition >= localController.value.duration) {
      if (!localController.value.isLooping) {
        localController.seekTo(Duration.zero);
      }

      widget.onAssetEnded?.call(widget.asset);
    }

    if (!localController.value.isPlaying) {
      _sendVideoWatchedAnalytics();
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

    if (_lastPosition > currentPosition &&
        _lastPosition.inMilliseconds > watchThresholdMS) {
      _loopCount++;
    }

    _lastPosition = currentPosition;

    if (localController.value.isPlaying && currentPosition > Duration.zero) {
      widget.onProgressUpdate?.call(
        widget.asset,
        currentPosition,
        localController.value.duration,
      );
    }
  }

  void _sendVideoWatchedAnalytics() {
    final localController = _controller;

    if (!_hasWatched ||
        !widget.options.trackAnalytics ||
        localController == null) {
      return;
    }

    final watchedSeconds =
        localController.value.position.inMicroseconds / 1000000.0 +
            (_loopCount *
                localController.value.duration.inMicroseconds /
                1000000.0);

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
        "videoDuration":
            localController.value.duration.inMicroseconds / 1000000.0,
      },
    );
    _loopCount = 0;
    _hasWatched = false;
  }

  void _updateControllerState() {
    final localController = _controller;

    if (localController == null) {
      return;
    }

    setState(() {
      if (widget.options.isPlaying) {
        localController.play();
      } else {
        localController.pause();
      }
      localController.setVolume(widget.options.isMuted ? 0.0 : 1.0);
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

  String _getVideoInfoText(VideoPlayerController? localController) {
    var text = localController != null && _isVideoInitialized && _isVideoReady
        ? (widget.options.playMode == AssetViewOptionsPlayMode.preview
            ? "Preview video."
            : "Video.")
        : "Preview image.";

    final localVideoPlayerValue = _videoPlayerValue;

    if (localVideoPlayerValue != null) {
      if (localVideoPlayerValue.isPlaying) {
        text += " Playing.";
      }

      if (localVideoPlayerValue.isBuffering) {
        text += " Buffering.";
      }

      if (localVideoPlayerValue.position != Duration.zero) {
        final position = localVideoPlayerValue.position;
        final minutes = position.inMinutes.remainder(60);
        final seconds = position.inSeconds.remainder(60);
        final milliseconds = position.inMilliseconds.remainder(1000);
        text +=
            ' $minutes:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(3, '0')}.';
      }

      if (localVideoPlayerValue.errorDescription != null) {
        text += " Error: ${localVideoPlayerValue.errorDescription}.";
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final localController = _controller;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          _thumbnailUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: CircularProgressIndicator()),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        if (localController != null && _isVideoInitialized)
          AnimatedOpacity(
            opacity: _isVideoReady ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: localController.value.size.height,
                width: localController.value.size.width,
                child: VideoPlayer(localController),
              ),
            ),
          ),
        if (widget.config.clientConfig?.videoDebugInfo ?? false)
          Positioned(
            top: 5,
            left: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.8),
              child: Text(
                _getVideoInfoText(localController),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
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
