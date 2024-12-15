import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

/*
  steps from config -> assets
*/
class TvPageConfig {
  final String publishId;
  final String appUrl;
  final String userId;
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
  }) buildProductsLoader;

  ProductsLoader? _productsLoader;

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
    required this.buildProductsLoader,
  });

  factory TvPageConfig.fromJson(
    Map<String, dynamic> json,
    ProductsLoader Function({
      required String appKey,
      required String appUrl,
      required List<Asset> assets,
    }) buildProductsLoader,
  ) {
    return TvPageConfig(
      publishId: json['publishId'] as String,
      appUrl: json['appUrl'] as String,
      userId: json['userId'] as String,
      assets: (json['steps'] as List)
          .map((step) => Asset.fromStepJson(step as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      id: json['id'] as String,
      startStep: json['startStep'] as String,
      appKey: json['appKey'] as String,
      owner: json['owner'] as String,
      buildProductsLoader: buildProductsLoader,
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
    ProductsLoader Function({
      required String appKey,
      required String appUrl,
      required List<Asset> assets,
    })? buildProductsLoader,
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
      buildProductsLoader: buildProductsLoader ?? this.buildProductsLoader,
    );
  }

  Future<List<Product>> getProducts(Asset asset) {
    _productsLoader ??= buildProductsLoader(
      appKey: appKey,
      appUrl: appUrl,
      assets: assets,
    );

    return _productsLoader!.getProducts(asset);
  }
}
