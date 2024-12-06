import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tolstoy_flutter_sdk/modules/api/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

const String _baseUrl = 'https://api.gotolstoy.com';

class ApiService {
  static Future<TvPageConfig> getTvPageConfig(String publishId) async {
    Uri url = Uri.parse(
        '$_baseUrl/settings/$publishId/player?feedShowUnviewedStepsFirst=false');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      List<String> vodAssetIds = (jsonData['steps'] as List<dynamic>?)
              ?.map((step) => step['videoId'] as String)
              .toList() ??
          [];
      String appUrl = jsonData['appUrl'] as String? ?? '';
      String appKey = jsonData['appKey'] as String? ?? '';

      ProductsMap productsMap =
          await getProductsByVodAssetIds(vodAssetIds, appUrl, appKey);

      TvPageConfig config = TvPageConfig.fromJson(jsonData, productsMap);

      return config;
    } else {
      throw Exception('Failed to load TV page config');
    }
  }

  static Future<ProductsMap> getProductsByVodAssetIds(
      List<String> vodAssetIds, String appUrl, String appKey) async {
    Uri url = Uri.parse('$_baseUrl/products/actions/v2/get-by-vod-asset-ids');

    Map<String, dynamic> requestBody = {
      'vodAssetIds': vodAssetIds,
      'appUrl': appUrl,
      'appKey': appKey,
    };

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      ProductsMap products = ProductsMap.fromJson(jsonData);

      return products;
    } else {
      throw Exception(
          'Failed to load actions by VOD asset IDs. Status code: ${response.statusCode}');
    }
  }

  static Future<bool> sendEvent(Map<String, dynamic> params) async {
    final result = await http.post(
      Uri.parse('$_baseUrl/events/event'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(params),
    );

    return result.statusCode == 200;
  }
}
