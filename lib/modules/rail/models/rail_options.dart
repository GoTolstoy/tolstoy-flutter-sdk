class RailOptions {
  const RailOptions({
    this.itemWidth = 144,
    this.itemHeight = 256,
    this.itemGap = 16,
    double? xPadding,
  }) : xPadding = xPadding ?? itemGap;

  final double itemWidth;
  final double itemHeight;
  final double itemGap;
  final double xPadding; // using itemGap as default xPadding
}
