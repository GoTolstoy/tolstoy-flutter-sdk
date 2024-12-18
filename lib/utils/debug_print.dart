import "package:tolstoy_flutter_sdk/core/config.dart";

enum DebugLevel {
  none,
  error,
  warning,
  info,
}

void debugError(dynamic message) {
  if (AppConfig.debugLevel == DebugLevel.info ||
      AppConfig.debugLevel == DebugLevel.warning ||
      AppConfig.debugLevel == DebugLevel.error) {
    // ignore: avoid_print
    print(message);
  }
}

void debugWarning(dynamic message) {
  if (AppConfig.debugLevel == DebugLevel.warning ||
      AppConfig.debugLevel == DebugLevel.error) {
    // ignore: avoid_print
    print(message);
  }
}

void debugInfo(dynamic message) {
  if (AppConfig.debugLevel == DebugLevel.error) {
    // ignore: avoid_print
    print(message);
  }
}
