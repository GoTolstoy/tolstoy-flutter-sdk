import "package:tolstoy_flutter_sdk/modules/api/services/api.dart";
import "package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart";
import "package:uuid/uuid.dart";

const uuid = Uuid();
const fractionDigits = 2;

enum AnalyticsEventType {
  pageView,
  embedView,
  sessionStart,

  videoClicked,
  videoLoaded,
  videoWatched,

  clickViewProduct,
}

enum AnalyticsMode {
  log,
  track,
  notrack,
}

class Analytics {
  factory Analytics([AnalyticsMode? mode]) {
    _instance ??= Analytics._(mode);
    return _instance!;
  }

  Analytics._(AnalyticsMode? mode) {
    _sessionId = uuid.v4();
    _anonymousId = uuid.v4();
    _mode = mode ?? AnalyticsMode.track;
  }

  static Analytics? _instance;
  late final String _sessionId;
  late final String _anonymousId;
  late final AnalyticsMode _mode;
  String get sessionId => _sessionId;
  String get anonymousId => _anonymousId;

  Future<void> _sendEvent(Map<String, dynamic> params) async {
    switch (_mode) {
      case AnalyticsMode.track:
        await ApiService.sendEvent(params);
      case AnalyticsMode.log:
        // ignore: avoid_print
        print("Params: $params");
      case AnalyticsMode.notrack:
        // Do nothing
        break;
    }
  }

  void sendPageView(TvPageConfig config) {
    final Map<String, dynamic> params = _getAnalyticsParams(
      config,
      {"eventName": AnalyticsEventType.pageView.name},
    );
    _sendEvent(params);
  }

  void sendEmbedView(TvPageConfig config) {
    final Map<String, dynamic> params = _getAnalyticsParams(
      config,
      {"eventName": AnalyticsEventType.embedView.name},
    );
    _sendEvent(params);
  }

  void sendSessionStart(TvPageConfig config) {
    final Map<String, dynamic> params = _getAnalyticsParams(
      config,
      {"eventName": AnalyticsEventType.sessionStart.name},
    );
    _sendEvent(params);
  }

  void sendVideoClicked(
    TvPageConfig config,
    Map<String, dynamic> dynamicParams,
  ) {
    final Map<String, dynamic> params = _getAnalyticsParams(
      config,
      {"eventName": AnalyticsEventType.videoClicked.name, ...dynamicParams},
    );
    _sendEvent(params);
  }

  void sendVideoLoaded(
    TvPageConfig config,
    Map<String, dynamic> dynamicParams,
  ) {
    final Map<String, dynamic> params = _getAnalyticsParams(
      config,
      {"eventName": AnalyticsEventType.videoLoaded.name, ...dynamicParams},
    );
    _sendEvent(params);
  }

  void sendVideoWatched(
    TvPageConfig config,
    Map<String, dynamic> dynamicParams,
  ) {
    final Map<String, dynamic> params = _getAnalyticsParams(
      config,
      {"eventName": AnalyticsEventType.videoWatched.name, ...dynamicParams},
    );
    _sendEvent(params);
  }

  void sendProductClicked(
    TvPageConfig config,
    Map<String, dynamic> dynamicParams,
  ) {
    final Map<String, dynamic> params = _getAnalyticsParams(config, {
      "eventName": AnalyticsEventType.clickViewProduct.name,
      ...dynamicParams,
    });
    _sendEvent(params);
  }

  Map<String, dynamic> _getAnalyticsParams(
    TvPageConfig config,
    Map<String, dynamic> dynamicParams,
  ) =>
      {
        "appKey": config.appKey,
        "publishId": config.publishId,
        "sessionId": _sessionId,
        "anonymousId": _anonymousId,
        "isMobile": true,
        "storeUrl": config.appUrl,
        "appUrl": config.appUrl,
        "projectId": config.id,
        "playlist": config.name,
        "timestamp": DateTime.now().toIso8601String(),
        ...dynamicParams,
      };
}
