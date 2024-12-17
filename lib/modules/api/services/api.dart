import "dart:convert";
import "package:http/http.dart" as http;
import "package:tolstoy_flutter_sdk/core/config.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";

class ApiService {
  static Future<TvPageConfig> getTvPageConfig(
    String publishId,
    ProductsLoader Function({
      required String appKey,
      required String appUrl,
      required List<Asset> assets,
    }) createProductsLoader,
  ) async {
    final url = Uri.parse(
      "${AppConfig.apilbBaseUrl}/settings${AppConfig.mobileAppFolder}/player/by-publish-id?publishId=$publishId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      final config =
          TvPageConfig.fromJson(jsonData, createProductsLoader);

      return config;
    } else {
      throw Exception("Failed to load TV page config");
    }
  }

  static Future<ProductsMap> getProductsByVodAssetIds(
    List<String> vodAssetIds,
    String appUrl,
    String appKey,
  ) async {
    final url = Uri.parse(
      "${AppConfig.apilbBaseUrl}/products/actions/v2${AppConfig.mobileAppFolder}/get-by-vod-asset-ids?appKey=$appKey&appUrl=$appUrl&vodAssetIds=${vodAssetIds.join(",")}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final products = ProductsMap.fromJson(jsonData);

      return products;
    } else {
      throw Exception(
        "Failed to load actions by VOD asset IDs. Status code: ${response.statusCode}",
      );
    }
  }

  static Future<bool> sendEvent(Map<String, dynamic> params) async {
    final result = await http.post(
      Uri.parse("${AppConfig.apiBaseUrl}/events/event"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(params),
    );

    return result.statusCode == 200;
  }
}
