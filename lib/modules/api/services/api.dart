import "dart:convert";
import "package:http/http.dart" as http;
import "package:tolstoy_flutter_sdk/core/config.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/utils/cast.dart";

typedef AnalyticsParams = Map<String, dynamic>;

class ApiService {
  static Future<TvPageConfig> getTvPageConfig(
    String publishId,
    ProductsLoaderFactory createProductsLoader,
  ) async {
    final url = Uri.parse(
      "${AppConfig.apilbBaseUrl}/settings${AppConfig.mobileAppFolder}/player/by-publish-id?publishId=$publishId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      const cast = Cast(location: "ApiService::getTvPageConfig");

      final jsonData =
          cast.jsonMapOrNull(json.decode(response.body), "response.body");

      if (jsonData == null) {
        throw Exception("Failed to load TV page config");
      }

      return TvPageConfig.fromJson(jsonData, createProductsLoader);
    } else {
      throw Exception(
        "Failed to load TV page config. Status code: ${response.statusCode}",
      );
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
      const cast = Cast(location: "ApiService::getProductsByVodAssetIds");

      final jsonData =
          cast.jsonMapOrNull(json.decode(response.body), "response.body");

      if (jsonData == null) {
        throw Exception("Failed to load products by VOD asset IDs");
      }

      return ProductsMap.fromJson(jsonData);
    } else {
      throw Exception(
        "Failed to load actions by VOD asset IDs. Status code: ${response.statusCode}",
      );
    }
  }

  static Future<bool> sendEvent(AnalyticsParams params) async {
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
