import "dart:convert";

import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:tolstoy_flutter_sdk/core/config.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/api/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";
import "package:tolstoy_flutter_sdk/utils/benchmarked_future.dart";
import "package:tolstoy_flutter_sdk/utils/cast.dart";
import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

typedef AnalyticsParams = Map<String, dynamic>;

class ApiService {
  static const _prefsPrefix = "cacheVersion_";

  static Future<SharedPreferences>? _sharedPreferences;
  static final _cacheVersionByAppKey = <String, Future<String>>{};

  static Future<TvPageConfig?> getTvPageConfig(
    String publishId,
    ProductsLoaderFactory createProductsLoader, {
    required String appKey,
    bool disableCache = false,
    SdkErrorCallback? onError,
  }) async {
    try {
      final benchmark = benchmarkedFutureStart();

      final cacheVersion = await _getCacheVersion(appKey, onError: onError);

      final endpoint = disableCache
          ? AppConfig.configEndpointUrl
          : AppConfig.configEndpointCacheUrl;

      final url = Uri.parse(
        "$endpoint?publishId=$publishId&v=$cacheVersion",
      );

      debugInfo("HTTP request: $url");

      final response = await benchmarkedFuture(
        http.get(url),
        "ApiService.getTvPageConfig.get",
      );

      benchmarkedFutureEnd(benchmark, "ApiService.getTvPageConfig");

      if (AppConfig.debugNetworkDelay != Duration.zero) {
        await Future.delayed(AppConfig.debugNetworkDelay);
      }

      if (response.statusCode == 200) {
        const cast = Cast(location: "ApiService.getTvPageConfig");

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
      final benchmark = benchmarkedFutureStart();

      final cacheVersion = await _getCacheVersion(appKey, onError: onError);

      final endpoint = disableCache
          ? AppConfig.productsEndpointUrl
          : AppConfig.productsEndpointCacheUrl;

      final url = Uri.parse(
        "$endpoint?appKey=$appKey&appUrl=$appUrl&vodAssetIds=${vodAssetIds.join(",")}&v=$cacheVersion",
      );

      debugInfo("HTTP request: $url");

      final response = await benchmarkedFuture(
        http.get(url),
        "ApiService.getProductsByVodAssetIds.get",
      );

      benchmarkedFutureEnd(benchmark, "ApiService.getProductsByVodAssetIds");

      if (AppConfig.debugNetworkDelay != Duration.zero) {
        await Future.delayed(AppConfig.debugNetworkDelay);
      }

      if (response.statusCode == 200) {
        const cast = Cast(location: "ApiService.getProductsByVodAssetIds");

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

  static Future<String> _getCacheVersion(
    String? appKey, {
    SdkErrorCallback? onError,
  }) async {
    if (appKey == null) {
      return "";
    }

    final cacheVersionFromApiFuture =
        _getCacheVersionFromApi(appKey, onError: onError);

    final cacheVersionFromPref = await _getCacheVersionFromPrefs(appKey);

    final cacheVersion =
        cacheVersionFromPref ?? await cacheVersionFromApiFuture;

    return cacheVersion;
  }

  static Future<String> _getCacheVersionFromApi(
    String appKey, {
    SdkErrorCallback? onError,
  }) async {
    final cacheVersion = _cacheVersionByAppKey[appKey] ??
        _getCacheVersionFromApiUncached(appKey, onError: onError);

    _cacheVersionByAppKey[appKey] = cacheVersion;

    return cacheVersion;
  }

  static Future<String> _getCacheVersionFromApiUncached(
    String appKey, {
    SdkErrorCallback? onError,
  }) async {
    var cacheVersion = "";

    final url = Uri.parse(AppConfig.cacheVersionEndpointUrl);

    debugInfo("HTTP request: $url");

    final response = await benchmarkedFuture(
      http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "appKey": appKey,
        }),
      ),
      "ApiService.getCacheVersion.post",
    );

    if (response.statusCode == 200) {
      const cast = Cast(location: "ApiService.getCacheVersion");

      final jsonData = cast.jsonMap(json.decode(response.body), "body");

      cacheVersion = cast.string(jsonData["cacheVersion"], "body.cacheVersion");
    } else {
      const message = "Failed to get cache version";
      debugError(message);
      onError?.call(message, StackTrace.current);
    }

    final prefs = await _getSharedPreferences();

    await prefs.setString("$_prefsPrefix$appKey", cacheVersion);

    return cacheVersion;
  }

  static Future<String?> _getCacheVersionFromPrefs(String appKey) async {
    final prefs = await _getSharedPreferences();

    return prefs.getString("$_prefsPrefix$appKey");
  }

  static Future<SharedPreferences> _getSharedPreferences() async {
    final sharedPreferences = _sharedPreferences ??
        benchmarkedFuture(
          SharedPreferences.getInstance(),
          "SharedPreferences.getInstance",
        );

    _sharedPreferences = sharedPreferences;

    return sharedPreferences;
  }
}
