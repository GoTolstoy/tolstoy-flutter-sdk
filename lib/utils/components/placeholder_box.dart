import "package:flutter/material.dart";

class PlaceholderBox extends StatelessWidget {
  const PlaceholderBox({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.baseColor,
  });

  final double width;
  final double height;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    final localBaseColor = baseColor ?? Colors.grey[300] ?? Colors.grey;

    return Container(
      width: width,
      height: height,
      color: localBaseColor,
    );
  }
}
