import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

/*
  steps from config -> assets
*/
class TvPageConfig {
  final String publishId;
  // final bool fastForwardEnabled;
  // final bool feedIsAnyStepShoppable;
  final String appUrl;
  final String userId;
  final List<Asset> assets;
  // final bool chatLandingPage;
  // final bool autoplay;
  // final bool feed;
  // final String baseUrl;
  // final bool verticalOrientation;
  final String name;
  // final String tolstoyType;
  // final bool dynamic;
  final String id;
  final String startStep;
  // final bool isMultipass;
  final String appKey;
  final String owner;
  final ProductsMap productsMap; // New field

  TvPageConfig({
    required this.publishId,
    // required this.fastForwardEnabled,
    // required this.feedIsAnyStepShoppable,
    required this.appUrl,
    required this.userId,
    required this.assets,
    // required this.chatLandingPage,
    // required this.autoplay,
    // required this.feed,
    // required this.baseUrl,
    // required this.verticalOrientation,
    required this.name,
    // required this.tolstoyType,
    // required this.dynamic,
    required this.id,
    required this.startStep,
    // required this.isMultipass,
    required this.appKey,
    required this.owner,
    required this.productsMap, // New parameter
  });

  factory TvPageConfig.fromJson(
      Map<String, dynamic> json, ProductsMap productsMap) {
    return TvPageConfig(
      publishId: json['publishId'],
      // fastForwardEnabled: json['fastForwardEnabled'],
      // feedIsAnyStepShoppable: json['feedIsAnyStepShoppable'],
      appUrl: json['appUrl'],
      userId: json['userId'],
      assets: (json['steps'] as List)
          .map((step) => Asset.fromStepJson(step))
          .toList(),
      // chatLandingPage: json['chatLandingPage'],
      // autoplay: json['autoplay'],
      // feed: json['feed'],
      // baseUrl: json['baseUrl'],
      // verticalOrientation: json['verticalOrientation'],
      name: json['name'],
      // tolstoyType: json['tolstoyType'],
      // dynamic: json['dynamic'],
      id: json['id'],
      startStep: json['startStep'],
      // isMultipass: json['isMultipass'],
      appKey: json['appKey'],
      owner: json['owner'],
      productsMap: productsMap, // Initialize new field
    );
  }

  TvPageConfig copyWith({
    String? publishId,
    String? appUrl,
    String? userId,
    List<Asset>? assets,
    String? name,
    String? id,
    String? startStep,
    String? appKey,
    String? owner,
    ProductsMap? productsMap, // New parameter
  }) {
    return TvPageConfig(
      publishId: publishId ?? this.publishId,
      appUrl: appUrl ?? this.appUrl,
      userId: userId ?? this.userId,
      assets: assets ?? this.assets,
      name: name ?? this.name,
      id: id ?? this.id,
      startStep: startStep ?? this.startStep,
      appKey: appKey ?? this.appKey,
      owner: owner ?? this.owner,
      productsMap: productsMap ?? this.productsMap,
    );
  }
}
