import "dart:async";

import "package:tolstoy_flutter_sdk/core/config.dart";
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

Future<T> benchmarkedFuture<T>(Future<T> future, String name) async {
  final startTime = DateTime.now();
  final result = await future;
  final endTime = DateTime.now();
  final duration = endTime.difference(startTime);

  if (duration > AppConfig.slowLoadingThreshold) {
    debugWarning("$name completed in ${duration.inMilliseconds} ms");
  } else {
    debugInfo("$name completed in ${duration.inMilliseconds} ms");
  }

  return result;
}

DateTime benchmarkedFutureStart() => DateTime.now();

void benchmarkedFutureEnd(DateTime startTime, String name) {
  final endTime = DateTime.now();
  final duration = endTime.difference(startTime);

  if (duration > AppConfig.slowLoadingThreshold) {
    debugWarning("$name completed in ${duration.inMilliseconds} ms");
  } else {
    debugInfo("$name completed in ${duration.inMilliseconds} ms");
  }
}
