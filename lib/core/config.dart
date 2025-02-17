// ignore_for_file: do_not_use_environment

import "package:tolstoy_flutter_sdk/utils/debug_print.dart";
import "package:tolstoy_flutter_sdk/utils/enum_from_string.dart";

class AppConfig {
  // ***************************************************************************
  // Options
  // ***************************************************************************

  static final _debugLevel = enumFromString(
    const String.fromEnvironment("TOLSTOY_FLUTTER_SDK_DEBUG_LEVEL"),
    DebugLevel.values,
    // Should be DebugLevel.none when commiting!!!
    DebugLevel.none,
  );

  // Should be Duration.zero when commiting!!!
  static const _debugNetworkDelay = Duration.zero;

  // Should be true when commiting!!!
  static const _mobileAppEndpoints = true;

  static const _prod =
      String.fromEnvironment("TOLSTOY_FLUTTER_SDK_PROD") != "false";

  static const _slowLoadingThreshold = Duration(milliseconds: 500);

  // Should be false when commiting!!!
  static const _videoDebugInfo = false;

  // ***************************************************************************
  // Local variables
  // ***************************************************************************

  static const _devPart = _prod ? "" : "dev-";

  static const _mobileAppPart = _mobileAppEndpoints ? "/mobile-app" : "";

  // ***************************************************************************
  // Configuration
  // ***************************************************************************

  static const analyticsEndpointUrl =
      "https://${_devPart}api.gotolstoy.com/events/event";

  static const cacheVersionEndpointUrl =
      "https://${_devPart}apilb.gotolstoy.com/settings/mobile-app/get-cache-version-by-app-key";

  static const categoriesEndpointUrl =
      "https://${_devPart}apilb.gotolstoy.com/settings/mobile-app/get-categories-by-app-key";

  static const categoriesEndpointCacheUrl =
      "https://${_devPart}cf-apilb.gotolstoy.com/settings/mobile-app/get-categories-by-app-key";

  static const configEndpointUrl =
      "https://${_devPart}apilb.gotolstoy.com/settings$_mobileAppPart/player/by-publish-id";

  static const configEndpointCacheUrl =
      "https://${_devPart}cf-apilb.gotolstoy.com/settings$_mobileAppPart/player/by-publish-id";

  static final debugLevel = _debugLevel;

  static const debugNetworkDelay = _debugNetworkDelay;

  static const productsEndpointUrl =
      "https://${_devPart}apilb.gotolstoy.com/products/actions/v2$_mobileAppPart/get-by-vod-asset-ids";

  static const productsEndpointCacheUrl =
      "https://${_devPart}cf-apilb.gotolstoy.com/products/actions/v2$_mobileAppPart/get-by-vod-asset-ids";

  static const slowLoadingThreshold = _slowLoadingThreshold;

  static const videoBaseUrl = _prod
      ? "https://videos.gotolstoy.com"
      : "https://dev-videos.gotolstoy.com";

  static const videoDebugInfo = _videoDebugInfo;
}
