const prod = true;

const useMobileEndpoints = true;

class AppConfig {
  static const String apiBaseUrl =
      prod ? "https://api.gotolstoy.com" : "https://dev-api.gotolstoy.com";

  static const String videoBaseUrl = prod
      ? "https://videos.gotolstoy.com"
      : "https://dev-videos.gotolstoy.com";

  static const String mobileEndpoint = useMobileEndpoints ? "/mobile" : "";
}
