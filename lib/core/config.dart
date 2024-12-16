const prod = true;

const useMobileEndpoints = true;

class AppConfig {
  static const String apiBaseUrl =
      prod ? 'https://api.gotolstoy.com' : 'https://dev-api.gotolstoy.com';

  static const String apilbBaseUrl =
      prod ? "https://apilb.gotolstoy.com" : "https://dev-apilb.gotolstoy.com";

  static const String videoBaseUrl = prod
      ? "https://videos.gotolstoy.com"
      : "https://dev-videos.gotolstoy.com";

  static const String mobileAppFolder = useMobileEndpoints ? "/mobile-app" : "";
}
