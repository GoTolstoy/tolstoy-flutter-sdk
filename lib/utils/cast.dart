// ignore_for_file: type_annotate_public_apis

class Cast {
  const Cast({
    required this.location,
  });

  final String location;

  List<dynamic> list(value, String key) {
    if (value is List) {
      return value;
    }

    // ignore: avoid_print
    print(
      "Cast.list: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return [];
  }

  Map<dynamic, dynamic> map(value, String key) {
    if (value is Map) {
      return value;
    }

    // ignore: avoid_print
    print(
      "Cast.map: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return {};
  }

  String string(value, String key) {
    if (value is String) {
      return value;
    }

    if (value is num) {
      return value.toString();
    }

    // ignore: avoid_print
    print(
      "Cast.string: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return "";
  }

  String? stringOrNull(value, String key) {
    if (value is String) {
      return value;
    }

    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toString();
    }

    // ignore: avoid_print
    print(
      "Cast.stringOrNull: Invalid value type for $location::$key (${value.runtimeType})",
    );

    return null;
  }
}
