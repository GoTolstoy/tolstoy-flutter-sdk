import "package:flutter/material.dart";

enum AssetViewOptionsPlayMode { full, preview }

class AssetViewOptions {
  const AssetViewOptions({
    this.isPlaying = false,
    this.isPlayingEnabled = true,
    this.isMuted = false,
    this.shouldLoop = false,
    this.withMuteButton = true,
    this.shouldImageEmulatePlaying = false,
    this.imagePlaytimeSec = 2,
    this.imageFit = BoxFit.contain,
    this.trackAnalytics = false,
    this.playMode = AssetViewOptionsPlayMode.full,
  });

  final bool isPlaying;
  final bool isPlayingEnabled;
  final bool isMuted;
  final bool shouldLoop;
  final bool withMuteButton;
  final bool shouldImageEmulatePlaying;
  final int imagePlaytimeSec;
  final BoxFit imageFit;
  final bool trackAnalytics;
  final AssetViewOptionsPlayMode playMode;

  AssetViewOptions copyWith({
    bool? isPlaying,
    bool? isPlayingEnabled,
    bool? isMuted,
    bool? shouldLoop,
    bool? withMuteButton,
    bool? shouldImageEmulatePlaying,
    int? imagePlaytimeSec,
    BoxFit? imageFit,
    bool? trackAnalytics,
    AssetViewOptionsPlayMode? playMode,
  }) =>
      AssetViewOptions(
        isPlaying: isPlaying ?? this.isPlaying,
        isPlayingEnabled: isPlayingEnabled ?? this.isPlayingEnabled,
        isMuted: isMuted ?? this.isMuted,
        shouldLoop: shouldLoop ?? this.shouldLoop,
        withMuteButton: withMuteButton ?? this.withMuteButton,
        shouldImageEmulatePlaying:
            shouldImageEmulatePlaying ?? this.shouldImageEmulatePlaying,
        imagePlaytimeSec: imagePlaytimeSec ?? this.imagePlaytimeSec,
        imageFit: imageFit ?? this.imageFit,
        trackAnalytics: trackAnalytics ?? this.trackAnalytics,
        playMode: playMode ?? this.playMode,
      );
}
