import "package:tolstoy_flutter_sdk/utils/cast.dart";

class JsonParser {
  JsonParser({
    required this.location,
    required this.json,
  }) : cast = Cast(location: location);

  final String location;
  final Map<dynamic, dynamic> json;
  final Cast cast;

  List<dynamic> list(String key) => cast.list(json[key], key);

  Map<dynamic, dynamic> map(String key) => cast.map(json[key], key);

  String string(String key) => cast.string(json[key], key);

  String? stringOrNull(String key) => cast.stringOrNull(json[key], key);
}
