import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart";

typedef SdkErrorCallback = void Function(
  String message,
  StackTrace? stackTrace, [
  Object? error,
]);

typedef VideoErrorCallback = Widget? Function(
  String message,
  Asset asset,
  AssetViewOptionsPlayMode playMode,
);

typedef PriceFormatter = Widget Function({
  required String price,
  required String currencySymbol,
});
