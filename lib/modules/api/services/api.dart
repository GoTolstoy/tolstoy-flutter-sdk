import "dart:convert";
import "package:http/http.dart" as http;
import "package:tolstoy_flutter_sdk/core/config.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/utils/cast.dart";
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

typedef AnalyticsParams = Map<String, dynamic>;

class ApiService {
  static Future<TvPageConfig?> getTvPageConfig(
    String publishId,
    ProductsLoaderFactory createProductsLoader, {
    bool disableCache = false,
    SdkErrorCallback? onError,
  }) async {
    final endpoint = disableCache
        ? AppConfig.configEndpointUrl
        : AppConfig.configEndpointCacheUrl;

    final url = Uri.parse(
      "$endpoint?publishId=$publishId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      const cast = Cast(location: "ApiService::getTvPageConfig");

      final jsonData =
          cast.jsonMapOrNull(json.decode(response.body), "response.body");

      if (jsonData == null) {
        const message = "Failed to load TV page config";
        debugError(message);
        onError?.call(message, StackTrace.current);
        return null;
      }

      return TvPageConfig.fromJson(jsonData, createProductsLoader, onError);
    } else {
      const message = "Failed to load TV page config";
      debugError(message);
      onError?.call(message, StackTrace.current);
      return null;
    }
  }

  static Future<ProductsMap> getProductsByVodAssetIds(
    List<String> vodAssetIds,
    String appUrl,
    String appKey, {
    bool disableCache = false,
    SdkErrorCallback? onError,
  }) async {
    final endpoint = disableCache
        ? AppConfig.productsEndpointUrl
        : AppConfig.productsEndpointCacheUrl;

    final url = Uri.parse(
      "$endpoint?appKey=$appKey&appUrl=$appUrl&vodAssetIds=${vodAssetIds.join(",")}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      const cast = Cast(location: "ApiService::getProductsByVodAssetIds");

      final jsonData =
          cast.jsonMapOrNull(json.decode(response.body), "response.body");

      if (jsonData == null) {
        const message = "Failed to load products by VOD asset IDs";
        debugError(message);
        onError?.call(message, StackTrace.current);
        return ProductsMap(products: {});
      }

      return ProductsMap.fromJson(jsonData);
    } else {
      const message = "Failed to load products by VOD asset IDs";
      debugError(message);
      onError?.call(message, StackTrace.current);
      return ProductsMap(products: {});
    }
  }

  static Future<bool> sendEvent(AnalyticsParams params) async {
    final result = await http.post(
      Uri.parse(AppConfig.analyticsEndpointUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(params),
    );

    return result.statusCode == 200;
  }
}
