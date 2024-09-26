import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/services.dart';

class ImageAsset extends StatefulWidget {
  const ImageAsset({
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
  State<ImageAsset> createState() => _ImageAssetState();
}

class _ImageAssetState extends State<ImageAsset> {
  Duration _progressTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.options.isPlaying) {
      _startPlaying();
    }
  }

  void _assetEnded() {
    if (widget.options.shouldLoop) {
      _progressTime = Duration.zero;
      return;
    }

    if (widget.onAssetEnded != null) {
      widget.onAssetEnded!(widget.asset);
    }
  }

  void _startPlaying() {
    const Duration tick = Duration(milliseconds: 100);
    Duration duration = Duration(seconds: widget.options.imagePlaytimeSec);

    Future.delayed(tick, () {
      if (!widget.options.isPlaying) return;

      _progressTime += tick;

      if (widget.onProgressUpdate != null) {
        widget.onProgressUpdate!(widget.asset, _progressTime, duration);
      }

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
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        AssetService.getAssetUrl(widget.asset),
        fit: widget.options.imageFit,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
