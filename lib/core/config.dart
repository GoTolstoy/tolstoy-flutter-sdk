import "package:tolstoy_flutter_sdk/utils/debug_print.dart";

const prod = true;

const useMobileEndpoints = true;

class AppConfig {
  static const debugLevel = prod ? DebugLevel.none : DebugLevel.info;

  static const apiBaseUrl =
      prod ? "https://api.gotolstoy.com" : "https://dev-api.gotolstoy.com";

  static const apilbBaseUrl =
      prod ? "https://apilb.gotolstoy.com" : "https://dev-apilb.gotolstoy.com";

  static const videoBaseUrl = prod
      ? "https://videos.gotolstoy.com"
      : "https://dev-videos.gotolstoy.com";

  static const mobileAppFolder = useMobileEndpoints ? "/mobile-app" : "";
}
