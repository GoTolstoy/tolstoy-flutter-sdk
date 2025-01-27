import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 2000),
    this.enabled = true,
  });

  final double width;
  final double height;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final localBaseColor = baseColor ?? Colors.grey[300] ?? Colors.grey;
    final localHighlightColor =
        highlightColor ?? Colors.grey[200] ?? Colors.grey;

    return Shimmer.fromColors(
      enabled: enabled,
      baseColor: localBaseColor,
      highlightColor: localHighlightColor,
      period: period,
      child: Container(
        width: width,
        height: height,
        color: localBaseColor,
      ),
    );
  }
}
