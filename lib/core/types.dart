import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";

typedef SdkErrorCallback = void Function(
  String message,
  StackTrace? stackTrace, [
  Object? error,
]);

typedef VideoErrorCallback = void Function(
  String message,
  Asset asset,
);
