import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:tolstoy_flutter_sdk/core/config.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/analytics/analytics.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/services.dart";
import "package:tolstoy_flutter_sdk/utils/components/delayed_display.dart";
import "package:video_player/video_player.dart";

const watchThresholdMS = 200;

class VideoAsset extends StatefulWidget {
  const VideoAsset({
    required this.asset,
    required this.config,
    this.clientConfig = const TvPageClientConfig(),
    super.key,
    this.onAssetEnded,
    this.onProgressUpdate,
    this.options = const AssetViewOptions(),
    this.preload = true,
    this.onVideoError,
  });

  final Asset asset;
  final TvPageConfig config;
  final TvPageClientConfig clientConfig;
  final Function(Asset)? onAssetEnded;
  final Function(
    Asset asset,
    Duration progress,
    Duration duration,
  )? onProgressUpdate;
  final AssetViewOptions options;
  final bool preload;
  final VideoErrorCallback? onVideoError;

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
  Widget? _errorWidget;

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

    localController.addListener(_videoPlayerListener);

    localController.initialize().then((_) {
      localController.setLooping(widget.options.shouldLoop);
      _updateControllerState();
      setState(() {
        _isVideoInitialized = true;
      });

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
    setState(() {});

    final localController = _controller;

    if (localController == null) {
      return;
    }

    if (localController.value.hasError) {
      _errorWidget = widget.onVideoError?.call(
        localController.value.errorDescription ?? "Unknown error",
        widget.asset,
        widget.options.playMode,
      );
    }

    if (!_isVideoInitialized) {
      return;
    }

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

  String _getVideoInfoText() {
    final localController = _controller;

    final isVideo =
        localController != null && _isVideoInitialized && _isVideoReady;

    final isPreview =
        widget.options.playMode == AssetViewOptionsPlayMode.preview;

    var text =
        isVideo ? (isPreview ? "Preview video." : "Video.") : "Preview image.";

    if (localController != null) {
      if (localController.value.isPlaying) {
        text += " Playing.";
      }

      if (localController.value.isBuffering) {
        text += " Buffering.";
      }

      if (localController.value.position != Duration.zero) {
        final position = localController.value.position;
        final minutes = position.inMinutes.remainder(60);
        final seconds = position.inSeconds.remainder(60);
        final milliseconds = position.inMilliseconds.remainder(1000);
        text +=
            ' $minutes:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(3, '0')}.';
      }

      if (localController.value.hasError) {
        text +=
            " Error: ${localController.value.errorDescription ?? "Unknown error"}.";
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final localController = _controller;
    final localErrorWidget = _errorWidget;
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Image.network(
            _thumbnailUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) => Center(
              child: SpinKitRing(
                color: Colors.white,
                size:
                    widget.options.playMode == AssetViewOptionsPlayMode.preview
                        ? 40
                        : 60,
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: SpinKitRing(
                  color: Colors.white,
                  lineWidth: widget.options.playMode ==
                          AssetViewOptionsPlayMode.preview
                      ? 5
                      : 7,
                  size: widget.options.playMode ==
                          AssetViewOptionsPlayMode.preview
                      ? 40
                      : 60,
                ),
              );
            },
          ),
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
        if (localController != null &&
            localController.value.hasError &&
            localErrorWidget != null)
          localErrorWidget,
        if (widget.clientConfig.videoBufferingIndicator &&
            widget.options.isPlaying &&
            localController != null &&
            _isVideoInitialized &&
            _isVideoReady)
          Center(
            child: DelayedDisplay(
              isVisible: localController.value.isBuffering,
              child: SpinKitRing(
                color: Colors.white,
                lineWidth:
                    widget.options.playMode == AssetViewOptionsPlayMode.preview
                        ? 5
                        : 7,
                size:
                    widget.options.playMode == AssetViewOptionsPlayMode.preview
                        ? 40
                        : 60,
              ),
            ),
          ),
        if (AppConfig.videoDebugInfo)
          Positioned(
            top: 5,
            left: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.8),
              child: Text(
                _getVideoInfoText(),
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
