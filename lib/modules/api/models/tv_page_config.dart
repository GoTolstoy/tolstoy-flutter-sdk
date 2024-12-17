import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/utils/cast.dart";
import "package:tolstoy_flutter_sdk/utils/json_parser.dart";
import "package:tolstoy_flutter_sdk/utils/types.dart";

class TvPageConfig {
  TvPageConfig({
    required this.publishId,
    required this.appUrl,
    required this.assets,
    required this.name,
    required this.id,
    required this.startStep,
    required this.appKey,
    required this.owner,
    required this.createProductsLoader,
    this.userId,
  }) : productsLoader = createProductsLoader(
          appKey: appKey,
          appUrl: appUrl,
          assets: assets,
        );

  factory TvPageConfig.fromJson(
    JsonMap json,
    ProductsLoader Function({
      required String appKey,
      required String appUrl,
      required List<Asset> assets,
    }) createProductsLoader,
  ) {
    final parse = JsonParser(
      location: "TvPageConfig",
      json: json,
    );

    const cast = Cast(location: "TvPageConfig");

    return TvPageConfig(
      publishId: parse.string("publishId"),
      appUrl: parse.string("appUrl"),
      assets: parse.list(
        "steps",
        (step) => Asset.fromStepJson(cast.jsonMap(step, "steps::step")),
      ),
      name: parse.string("name"),
      id: parse.string("id"),
      startStep: parse.string("startStep"),
      appKey: parse.string("appKey"),
      owner: parse.string("owner"),
      userId: parse.stringOrNull("userId"),
      createProductsLoader: createProductsLoader,
    );
  }

  final String publishId;
  final String appUrl;
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
  final String? userId;
  final ProductsLoader productsLoader;

  TvPageConfig copyWith({
    String? publishId,
    String? appUrl,
    List<Asset>? assets,
    String? name,
    String? id,
    String? startStep,
    String? appKey,
    String? owner,
    String? userId,
    ProductsLoader Function({
      required String appKey,
      required String appUrl,
      required List<Asset> assets,
    })? createProductsLoader,
  }) =>
      TvPageConfig(
        publishId: publishId ?? this.publishId,
        appUrl: appUrl ?? this.appUrl,
        assets: assets ?? this.assets,
        name: name ?? this.name,
        id: id ?? this.id,
        startStep: startStep ?? this.startStep,
        appKey: appKey ?? this.appKey,
        owner: owner ?? this.owner,
        userId: userId ?? this.userId,
        createProductsLoader: createProductsLoader ?? this.createProductsLoader,
      );
}
