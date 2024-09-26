import 'package:flutter/material.dart';

class AssetViewOptions {
  final bool isPlaying;
  final bool isMuted;
  final bool shouldLoop;

  final bool withMuteButton;

  final bool shouldImageEmulatePlaying;
  final int imagePlaytimeSec;
  final BoxFit imageFit;

  const AssetViewOptions({
    this.isPlaying = false,
    this.isMuted = false,
    this.shouldLoop = false,

    this.withMuteButton = true,

    // image specific settings
    this.shouldImageEmulatePlaying = false,
    this.imagePlaytimeSec = 2,
    this.imageFit = BoxFit.contain,
  });
}
