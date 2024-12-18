import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

class AppConfig {
  // Options

  static const _debugLevel = DebugLevel.info;

  static const _mobileAppEndpoints = true;

  static const _prod = true;

  // Local variables

  static const _devPart = _prod ? "" : "dev-";

  static const _mobileAppPart = _mobileAppEndpoints ? "/mobile-app" : "";

  // Configuration

  static const analyticsEndpointUrl =
      "https://${_devPart}api.gotolstoy.com/events/event";

  static const configEndpointUrl =
      "https://${_devPart}apilb.gotolstoy.com/settings$_mobileAppPart/player/by-publish-id";

  static const configEndpointCacheUrl =
      "https://${_devPart}cf-apilb.gotolstoy.com/settings$_mobileAppPart/player/by-publish-id";

  static const debugLevel = _debugLevel;

  static const productsEndpointUrl =
      "https://${_devPart}apilb.gotolstoy.com/products/actions/v2$_mobileAppPart/get-by-vod-asset-ids";

  static const productsEndpointCacheUrl =
      "https://${_devPart}cf-apilb.gotolstoy.com/products/actions/v2$_mobileAppPart/get-by-vod-asset-ids";

  static const videoBaseUrl = _prod
      ? "https://videos.gotolstoy.com"
      : "https://dev-videos.gotolstoy.com";
}
