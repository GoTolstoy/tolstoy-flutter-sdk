import "package:tolstoy_flutter_sdk/modules/assets/constants/asset_type.dart";

class Asset {
  Asset({
    required this.products,
    required this.name,
    required this.owner,
    required this.id,
    required this.createdAt,
    required this.uploadType,
    required this.type,
    this.stockAsset,
  });

  factory Asset.fromStepJson(Map<String, dynamic> json) {
    final AssetType type = AssetType.values.firstWhere(
      (e) => e.toString() == 'AssetType.${json['type'] ?? 'video'}',
      orElse: () => AssetType.video,
    );

    return Asset(
      id: json["videoId"] as String,
      name: json["videoName"] as String?,
      owner: json["videoOwner"] as String,
      uploadType: json["uploadType"] as String,
      type: type,
      createdAt: json["videoCreatedAt"] != null
          ? DateTime.parse(json["videoCreatedAt"] as String)
          : null,
      stockAsset: json["stockAsset"] != null
          ? StockAsset.fromJson(json["stockAsset"] as Map<String, dynamic>)
          : null,
      products: (json["products"] as List?)
              ?.map(
                (product) =>
                    ProductReference.fromJson(product as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  final List<ProductReference> products;
  final String? name;
  final String owner;
  final String id;
  final StockAsset? stockAsset;
  final DateTime? createdAt;
  final String uploadType;
  final AssetType type;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "owner": owner,
        "uploadType": uploadType,
        "type": type,
        "createdAt": createdAt,
        "stockAsset": stockAsset?.toJson(),
        "products": products.map((product) => product.toJson()).toList(),
      };
}

class ProductReference {
  ProductReference({required this.id, this.variantIds});

  factory ProductReference.fromJson(Map<String, dynamic> json) =>
      ProductReference(
        id: json["id"] as String,
        variantIds: (json["variantIds"] as List<dynamic>?)?.cast<String>(),
      );

  final String id;
  final List<String>? variantIds;

  Map<String, dynamic> toJson() => {
        "id": id,
        "variantIds": variantIds,
      };
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

  factory StockAsset.fromJson(Map<String, dynamic> json) => StockAsset(
        previewShopifyFileId: json["previewShopifyFileId"] as String?,
        previewUrl: json["previewUrl"] as String?,
        posterUrl: json["posterUrl"] as String?,
        videoUrl: json["videoUrl"] as String?,
        hasOriginal: json["hasOriginal"] as bool?,
        shopifyPosterUrl: json["shopifyPosterUrl"] as String?,
        shopifyFileId: json["shopifyFileId"] as String?,
      );

  final String? previewShopifyFileId;
  final String? previewUrl;
  final String? posterUrl;
  final String? videoUrl;
  final bool? hasOriginal;
  final String? shopifyPosterUrl;
  final String? shopifyFileId;

  Map<String, dynamic> toJson() => {
        "previewShopifyFileId": previewShopifyFileId,
        "previewUrl": previewUrl,
        "posterUrl": posterUrl,
        "videoUrl": videoUrl,
        "hasOriginal": hasOriginal,
        "shopifyPosterUrl": shopifyPosterUrl,
        "shopifyFileId": shopifyFileId,
      };
}
