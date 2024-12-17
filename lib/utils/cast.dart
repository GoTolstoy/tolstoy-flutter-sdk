import "package:tolstoy_flutter_sdk/utils/debug_print.dart";
import "package:tolstoy_flutter_sdk/utils/types.dart";

class Cast {
  const Cast({
    required this.location,
  });

  final String location;

  bool boolean(dynamic value, String key) {
    if (value is bool) {
      return value;
    }

    debugWarning(
      "Cast.boolean: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return false;
  }

  bool? booleanOrNull(dynamic value, String key) {
    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    debugWarning(
      "Cast.booleanOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }

  DateTime dateTime(dynamic value, String key) {
    if (value is String) {
      try {
        return DateTime.parse(value);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        debugWarning(
          "Cast.dateTime: Invalid value for $location::$key ($value)",
        );

        return DateTime.now();
      }
    }

    debugWarning(
      "Cast.dateTime: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return DateTime.now();
  }

  DateTime? dateTimeOrNull(dynamic value, String key) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      try {
        return DateTime.parse(value);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        debugWarning(
          "Cast.dateTimeOrNull: Invalid value for $location::$key ($value)",
        );

        return null;
      }
    }

    debugWarning(
      "Cast.dateTimeOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }

  double doubleValue(dynamic value, String key) {
    if (value is num) {
      return value.toDouble();
    }

    debugWarning(
      "Cast.doubleValue: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return 0;
  }

  double? doubleValueOrNull(dynamic value, String key) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    debugWarning(
      "Cast.doubleValueOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }

  int integer(dynamic value, String key) {
    if (value is num) {
      return value.toInt();
    }

    debugWarning(
      "Cast.integer: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return 0;
  }

  int? integerOrNull(dynamic value, String key) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toInt();
    }

    debugWarning(
      "Cast.integerOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }

  JsonMap jsonMap(dynamic value, String key) {
    if (value is Map) {
      return value;
    }

    debugWarning(
      "Cast.map: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return {};
  }

  JsonMap? jsonMapOrNull(dynamic value, String key) {
    if (value == null) {
      return null;
    }

    if (value is Map) {
      return value;
    }

    debugWarning(
      "Cast.mapOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }

  List<T> list<T>(
    dynamic value,
    String key,
    ConversionFunction<T> converter,
  ) {
    if (value is List) {
      return value.map(converter).toList();
    }

    debugWarning(
      "Cast.list: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return [];
  }

  List<T>? listOrNull<T>(
    dynamic value,
    String key,
    ConversionFunction<T> converter,
  ) {
    if (value == null) {
      return null;
    }

    if (value is List) {
      return value.map(converter).toList();
    }

    debugWarning(
      "Cast.listOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }

  Map<String, T> map<T>(
    dynamic value,
    String key,
    ConversionFunction<T> converter,
  ) {
    if (value is Map) {
      return _buildMap(value, converter);
    }

    debugWarning(
      "Cast.map: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return {};
  }

  Map<String, T>? mapOrNull<T>(
    dynamic value,
    String key,
    ConversionFunction<T> converter,
  ) {
    if (value == null) {
      return null;
    }

    if (value is Map) {
      return _buildMap(value, converter);
    }

    debugWarning(
      "Cast.mapOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }

  String string(dynamic value, String key) {
    if (value is String) {
      return value;
    }

    if (value is num) {
      return value.toString();
    }

    debugWarning(
      "Cast.string: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return "";
  }

  String? stringOrNull(dynamic value, String key) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    if (value is num) {
      return value.toString();
    }

    debugWarning(
      "Cast.stringOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }

  Map<String, T> _buildMap<T>(
    Map<dynamic, dynamic> value,
    ConversionFunction<T> converter,
  ) {
    final result = <String, T>{};

    for (final entry in value.entries) {
      final key = entry.key;

      if (key is! String) {
        continue;
      }

      result[key] = converter(entry.value);
    }

    return result;
  }
}
