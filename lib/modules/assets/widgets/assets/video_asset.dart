import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/services.dart';

class VideoAsset extends StatefulWidget {
  const VideoAsset({
    super.key,
    required this.asset,
    this.onAssetEnded,
    this.onProgressUpdate,
    this.options = const AssetViewOptions(),
  });

  final Asset asset;
  final Function(Asset)? onAssetEnded;
  final Function(
    Asset asset,
    Duration progress,
    Duration duration,
  )? onProgressUpdate;
  final AssetViewOptions options;

  @override
  State<VideoAsset> createState() => _VideoAssetState();
}

class _VideoAssetState extends State<VideoAsset> {
  late VideoPlayerController _controller;
  late String _thumbnailUrl;

  @override
  void initState() {
    super.initState();

    final url = AssetService.getAssetUrl(widget.asset);
    _thumbnailUrl = AssetService.getPosterUrl(widget.asset);

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    )..initialize().then((_) {
        _updateControllerState();
        _controller.addListener(_videoPlayerListener);
        setState(() {});
      });
  }

  void _videoPlayerListener() {
    if (_controller.value.isPlaying &&
        widget.onProgressUpdate != null &&
        _controller.value.position > Duration.zero) {
      widget.onProgressUpdate!(
          widget.asset, _controller.value.position, _controller.value.duration);
    }

    // loop video if ended
    if (widget.options.shouldLoop &&
        _controller.value.position >= _controller.value.duration) {
      _controller.seekTo(Duration.zero);
      _controller.play();
      return;
    }

    if (widget.onAssetEnded != null) {
      widget.onAssetEnded!(widget.asset);
    }
  }

  void _updateControllerState() {
    setState(() {
      if (widget.options.isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
      _controller.setVolume(widget.options.isMuted ? 0.0 : 1.0);
    });
  }

  @override
  void didUpdateWidget(VideoAsset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options.isPlaying != widget.options.isPlaying ||
        oldWidget.options.isMuted != widget.options.isMuted) {
      _updateControllerState();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized ||
        (!_controller.value.isPlaying &&
            _controller.value.position == Duration.zero)) {
      return Image.network(
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
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: _controller.value.size.height,
            width: _controller.value.size.width,
            child: VideoPlayer(_controller),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_videoPlayerListener);
    _controller.dispose();
    super.dispose();
  }
}
