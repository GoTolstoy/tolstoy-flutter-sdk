import "package:tolstoy_flutter_sdk/modules/assets/constants/asset_type.dart";
import "package:tolstoy_flutter_sdk/utils/cast.dart";
import "package:tolstoy_flutter_sdk/utils/enum_from_string.dart";
import "package:tolstoy_flutter_sdk/utils/json_parser.dart";
import "package:tolstoy_flutter_sdk/utils/types.dart";

class Asset {
  Asset({
    required this.owner,
    required this.id,
    required this.uploadType,
    required this.type,
    this.products,
    this.name,
    this.stockAsset,
    this.externalProviderData,
    this.createdAt,
  });

  factory Asset.fromStepJson(JsonMap json) {
    final parse = JsonParser(
      location: "Asset",
      json: json,
    );

    const cast = Cast(location: "Asset");

    final stockAsset = parse.jsonMapOrNull("stockAsset");
    final externalProviderData = parse.jsonMapOrNull("externalProviderData");

    return Asset(
      owner: parse.string("videoOwner"),
      id: parse.string("videoId"),
      uploadType: parse.string("uploadType"),
      type: enumFromString(
        parse.stringOrNull("type"),
        AssetType.values,
        AssetType.video,
      ),
      products: parse.listOrNull(
        "products",
        (product) => ProductReference.fromJson(
          cast.jsonMap(product, "products::product"),
        ),
      ),
      name: parse.stringOrNull("videoName"),
      createdAt: parse.dateTimeOrNull("videoCreatedAt"),
      stockAsset: stockAsset != null ? StockAsset.fromJson(stockAsset) : null,
      externalProviderData: externalProviderData != null
          ? ExternalProviderData.fromJson(externalProviderData)
          : null,
    );
  }

  final String owner;
  final String id;
  final String uploadType;
  final AssetType type;
  final List<ProductReference>? products;
  final String? name;
  final StockAsset? stockAsset;
  final ExternalProviderData? externalProviderData;
  final DateTime? createdAt;
}

class ProductReference {
  ProductReference({required this.id, this.variantIds});

  factory ProductReference.fromJson(JsonMap json) {
    final parse = JsonParser(
      location: "ProductReference",
      json: json,
    );

    const cast = Cast(location: "ProductReference");

    return ProductReference(
      id: parse.string("id"),
      variantIds: parse.listOrNull(
        "variantIds",
        (variantId) => cast.string(variantId, "variantIds::variantId"),
      ),
    );
  }

  final String id;
  final List<String>? variantIds;
}

class StockAsset {
  StockAsset({
    this.previewShopifyFileId,
    this.previewUrl,
    this.posterUrl,
    this.videoUrl,
    this.hasOriginal,
    this.shopifyPosterUrl,
    this.shopifyFileId,
  });

  factory StockAsset.fromJson(JsonMap json) {
    final parse = JsonParser(
      location: "StockAsset",
      json: json,
    );

    return StockAsset(
      previewShopifyFileId: parse.stringOrNull("previewShopifyFileId"),
      previewUrl: parse.stringOrNull("previewUrl"),
      posterUrl: parse.stringOrNull("posterUrl"),
      videoUrl: parse.stringOrNull("videoUrl"),
      hasOriginal: parse.booleanOrNull("hasOriginal"),
      shopifyPosterUrl: parse.stringOrNull("shopifyPosterUrl"),
      shopifyFileId: parse.stringOrNull("shopifyFileId"),
    );
  }

  final String? previewShopifyFileId;
  final String? previewUrl;
  final String? posterUrl;
  final String? videoUrl;
  final bool? hasOriginal;
  final String? shopifyPosterUrl;
  final String? shopifyFileId;
}

class ExternalProviderData {
  ExternalProviderData({
    this.handle,
  });

  factory ExternalProviderData.fromJson(JsonMap json) {
    final parse = JsonParser(
      location: "ExternalProviderData",
      json: json,
    );

    return ExternalProviderData(
      handle: parse.stringOrNull("handle"),
    );
  }

  final String? handle;
}
