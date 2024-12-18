T enumFromString<T>(String? key, List<T> values, T defaultValue) =>
    values.firstWhere(
      (value) => value.toString().split(".").last == key,
      orElse: () => defaultValue,
    );
