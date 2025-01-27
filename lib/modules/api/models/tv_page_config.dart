import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart";
import "package:tolstoy_flutter_sdk/utils/cast.dart";
import "package:tolstoy_flutter_sdk/utils/components/shimmer_box.dart";
import "package:tolstoy_flutter_sdk/utils/json_parser.dart";
import "package:tolstoy_flutter_sdk/utils/types.dart";

class TvPageClientConfig {
  TvPageClientConfig({
    this.appKey,
    this.videoBufferingIndicator = true,
    this.staleWhileRevalidate = true,
    this.placeholderWidget = const ShimmerBox(),
  });

  final String? appKey;
  final bool videoBufferingIndicator;
  final bool staleWhileRevalidate;
  final Widget placeholderWidget;
}

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
    required this.clientConfig,
    this.onError,
    this.userId,
  }) : productsLoader = createProductsLoader(
          appKey: appKey,
          appUrl: appUrl,
          assets: assets,
        );

  factory TvPageConfig.fromJson(
    JsonMap json,
    ProductsLoaderFactory createProductsLoader, {
    TvPageClientConfig? clientConfig,
    SdkErrorCallback? onError,
  }) {
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
      clientConfig: clientConfig ?? TvPageClientConfig(),
      onError: onError,
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
  final ProductsLoaderFactory createProductsLoader;
  final TvPageClientConfig clientConfig;
  final SdkErrorCallback? onError;
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
    ProductsLoaderFactory? createProductsLoader,
    TvPageClientConfig? clientConfig,
    SdkErrorCallback? onError,
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
        clientConfig: clientConfig ?? this.clientConfig,
        onError: onError ?? this.onError,
      );

  Future<List<Product>> getProducts(Asset asset) =>
      productsLoader.getProducts(asset, onError);

  void preload(List<Asset> assets) {
    productsLoader.preload(assets, onError);
  }
}
