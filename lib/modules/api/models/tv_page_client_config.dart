import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/utils/components/placeholder_box.dart";
import "package:tolstoy_flutter_sdk/utils/components/shimmer_box.dart";

class TvPageClientConfig {
  const TvPageClientConfig({
    this.videoBufferingIndicator = true,
    this.placeholderWidget = const PlaceholderBox(),
    this.loadingPlaceholderWidget = const ShimmerBox(),
  });

  final bool videoBufferingIndicator;
  final Widget placeholderWidget;
  final Widget loadingPlaceholderWidget;
}
