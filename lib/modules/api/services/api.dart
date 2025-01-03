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
    TvPageClientConfig? clientConfig,
    SdkErrorCallback? onError,
  }) async {
    try {
      final endpoint = disableCache
          ? AppConfig.configEndpointUrl
          : AppConfig.configEndpointCacheUrl;

      final url = Uri.parse(
        "$endpoint?publishId=$publishId",
      );

      debugInfo("HTTP request: $url");

      final response = await http.get(url);

      if (AppConfig.debugNetworkDelay != Duration.zero) {
        await Future.delayed(AppConfig.debugNetworkDelay);
      }

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

        return TvPageConfig.fromJson(
          jsonData,
          createProductsLoader,
          clientConfig: clientConfig,
          onError: onError,
        );
      } else {
        const message = "Failed to load TV page config";
        debugError(message);
        onError?.call(message, StackTrace.current);
        return null;
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      const message = "Failed to load TV page config";
      debugError("$message: $e");
      onError?.call(message, StackTrace.current, e);
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
    try {
      final endpoint = disableCache
          ? AppConfig.productsEndpointUrl
          : AppConfig.productsEndpointCacheUrl;

      final url = Uri.parse(
        "$endpoint?appKey=$appKey&appUrl=$appUrl&vodAssetIds=${vodAssetIds.join(",")}",
      );

      debugInfo("HTTP request: $url");

      final response = await http.get(url);

      if (AppConfig.debugNetworkDelay != Duration.zero) {
        await Future.delayed(AppConfig.debugNetworkDelay);
      }

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
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      const message = "Failed to load products by VOD asset IDs";
      debugError("$message: $e");
      onError?.call(message, StackTrace.current, e);
      return ProductsMap(products: {});
    }
  }

  static Future<bool> sendEvent(
    AnalyticsParams params, {
    required SdkErrorCallback? onError,
  }) async {
    try {
      final result = await http.post(
        Uri.parse(AppConfig.analyticsEndpointUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(params),
      );

      return result.statusCode == 200;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      const message = "Failed to send event";
      debugError("$message: $e");
      onError?.call(message, StackTrace.current, e);
      return false;
    }
  }
}
