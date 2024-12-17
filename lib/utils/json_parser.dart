import "package:tolstoy_flutter_sdk/utils/cast.dart";
import "package:tolstoy_flutter_sdk/utils/types.dart";

class JsonParser {
  JsonParser({
    required this.location,
    required this.json,
  }) : cast = Cast(location: location);

  final String location;
  final JsonMap json;
  final Cast cast;

  bool boolean(String key) => cast.boolean(json[key], key);

  bool? booleanOrNull(String key) => cast.booleanOrNull(json[key], key);

  DateTime dateTime(String key) => cast.dateTime(json[key], key);

  DateTime? dateTimeOrNull(String key) => cast.dateTimeOrNull(json[key], key);

  double doubleValue(String key) => cast.doubleValue(json[key], key);

  double? doubleValueOrNull(String key) =>
      cast.doubleValueOrNull(json[key], key);

  int integer(String key) => cast.integer(json[key], key);

  int? integerOrNull(String key) => cast.integerOrNull(json[key], key);

  JsonMap jsonMap(String key) => cast.jsonMap(json[key], key);

  JsonMap? jsonMapOrNull(String key) => cast.jsonMapOrNull(json[key], key);

  List<T> list<T>(String key, ConversionFunction<T> converter) =>
      cast.list(json[key], key, converter);

  List<T>? listOrNull<T>(String key, ConversionFunction<T> converter) =>
      cast.listOrNull(json[key], key, converter);

  Map<String, T> map<T>(String key, ConversionFunction<T> converter) =>
      cast.map(json[key], key, converter);

  Map<String, T>? mapOrNull<T>(
    String key,
    ConversionFunction<T> converter,
  ) =>
      cast.mapOrNull(json[key], key, converter);

  String string(String key) => cast.string(json[key], key);

  String? stringOrNull(String key) => cast.stringOrNull(json[key], key);
}
