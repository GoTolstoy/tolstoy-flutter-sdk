import 'package:flutter/material.dart';

enum AssetViewOptionsPlayMode { full, preview }

class AssetViewOptions {
  final bool isPlaying;
  final bool isMuted;
  final bool shouldLoop;
  final bool withMuteButton;
  final bool shouldImageEmulatePlaying;
  final int imagePlaytimeSec;
  final BoxFit imageFit;
  final bool trackAnalytics;
  final AssetViewOptionsPlayMode playMode;

  const AssetViewOptions({
    this.isPlaying = false,
    this.isMuted = false,
    this.shouldLoop = false,
    this.withMuteButton = true,
    this.shouldImageEmulatePlaying = false,
    this.imagePlaytimeSec = 2,
    this.imageFit = BoxFit.contain,
    this.trackAnalytics = false,
    this.playMode = AssetViewOptionsPlayMode.full,
  });

  AssetViewOptions copyWith({
    bool? isPlaying,
    bool? isMuted,
    bool? shouldLoop,
    bool? withMuteButton,
    bool? shouldImageEmulatePlaying,
    int? imagePlaytimeSec,
    BoxFit? imageFit,
    bool? trackAnalytics,
    AssetViewOptionsPlayMode? playMode,
  }) {
    return AssetViewOptions(
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      shouldLoop: shouldLoop ?? this.shouldLoop,
      withMuteButton: withMuteButton ?? this.withMuteButton,
      shouldImageEmulatePlaying: shouldImageEmulatePlaying ?? this.shouldImageEmulatePlaying,
      imagePlaytimeSec: imagePlaytimeSec ?? this.imagePlaytimeSec,
      imageFit: imageFit ?? this.imageFit,
      trackAnalytics: trackAnalytics ?? this.trackAnalytics,
      playMode: playMode ?? this.playMode,
    );
  }
}
