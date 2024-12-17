import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/utils/cast.dart";
import "package:tolstoy_flutter_sdk/utils/json_parser.dart";

class TvPageConfig {
  TvPageConfig({
    required this.publishId,
    required this.appUrl,
    required this.userId,
    required this.assets,
    required this.name,
    required this.id,
    required this.startStep,
    required this.appKey,
    required this.owner,
    required this.createProductsLoader,
  }) : productsLoader = createProductsLoader(
          appKey: appKey,
          appUrl: appUrl,
          assets: assets,
        );

  factory TvPageConfig.fromJson(
    Map<dynamic, dynamic> json,
    ProductsLoader Function({
      required String appKey,
      required String appUrl,
      required List<Asset> assets,
    }) createProductsLoader,
  ) {
    final parse = JsonParser(
      location: "tv_page_config",
      json: json,
    );

    const cast = Cast(location: "tv_page_config");

    return TvPageConfig(
      publishId: parse.string("publishId"),
      appUrl: parse.string("appUrl"),
      userId: parse.stringOrNull("userId"),
      assets: parse
          .list("steps")
          .map((step) => Asset.fromStepJson(cast.map(step, "steps::step")))
          .toList(),
      name: parse.string("name"),
      id: parse.string("id"),
      startStep: parse.string("startStep"),
      appKey: parse.string("appKey"),
      owner: parse.string("owner"),
      createProductsLoader: createProductsLoader,
    );
  }

  final String publishId;
  final String appUrl;
  final String? userId;
  final List<Asset> assets;
  final String name;
  final String id;
  final String startStep;
  final String appKey;
  final String owner;
  final ProductsLoader Function({
    required String appKey,
    required String appUrl,
    required List<Asset> assets,
  }) createProductsLoader;
  final ProductsLoader productsLoader;

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
    ProductsLoader Function({
      required String appKey,
      required String appUrl,
      required List<Asset> assets,
    })? createProductsLoader,
  }) =>
      TvPageConfig(
        publishId: publishId ?? this.publishId,
        appUrl: appUrl ?? this.appUrl,
        userId: userId ?? this.userId,
        assets: assets ?? this.assets,
        name: name ?? this.name,
        id: id ?? this.id,
        startStep: startStep ?? this.startStep,
        appKey: appKey ?? this.appKey,
        owner: owner ?? this.owner,
        createProductsLoader: createProductsLoader ?? this.createProductsLoader,
      );
}
