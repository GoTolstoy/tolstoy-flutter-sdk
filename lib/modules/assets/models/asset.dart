import 'package:tolstoy_flutter_sdk/modules/assets/constants/asset_type.dart';

class Asset {
  final List<ProductReference> products;
  final String name;
  final String owner;
  final String id;
  final StockAsset? stockAsset;
  final DateTime? createdAt;
  final String uploadType;
  final AssetType type;

  Asset({
    required this.products,
    required this.name,
    required this.owner,
    required this.id,
    this.stockAsset,
    required this.createdAt,
    required this.uploadType,
    required this.type,
  });

  factory Asset.fromStepJson(Map<String, dynamic> json) {
    AssetType type = AssetType.values.firstWhere(
      (e) => e.toString() == 'AssetType.${json['type'] ?? 'video'}',
      orElse: () => AssetType.video,
    );

    return Asset(
      id: json['videoId'] as String,
      name: json['videoName'] as String,
      owner: json['videoOwner'] as String,
      uploadType: json['uploadType'] as String,
      type: type,
      createdAt: json['videoCreatedAt'] != null
          ? DateTime.parse(json['videoCreatedAt'] as String)
          : null,
      stockAsset: json['stockAsset'] != null
          ? StockAsset.fromJson(json['stockAsset'] as Map<String, dynamic>)
          : null,
      products: (json['products'] as List?)
              ?.map((product) =>
                  ProductReference.fromJson(product as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner': owner,
      'uploadType': uploadType,
      'type': type,
      'createdAt': createdAt,
      'stockAsset': stockAsset?.toJson(),
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

class ProductReference {
  final String id;
  final List<String>? variantIds;

  ProductReference({required this.id, this.variantIds});

  factory ProductReference.fromJson(Map<String, dynamic> json) {
    return ProductReference(
      id: json['id'] as String,
      variantIds: (json['variantIds'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variantIds': variantIds,
    };
  }
}

class StockAsset {
  final String? previewShopifyFileId;
  final String? previewUrl;
  final String? posterUrl;
  final String? videoUrl;
  final bool? hasOriginal;
  final String? shopifyPosterUrl;
  final String? shopifyFileId;

  StockAsset({
    this.previewShopifyFileId,
    this.previewUrl,
    this.posterUrl,
    this.videoUrl,
    this.hasOriginal,
    this.shopifyPosterUrl,
    this.shopifyFileId,
  });

  factory StockAsset.fromJson(Map<String, dynamic> json) {
    return StockAsset(
      previewShopifyFileId: json['previewShopifyFileId'] as String?,
      previewUrl: json['previewUrl'] as String?,
      posterUrl: json['posterUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      hasOriginal: json['hasOriginal'] as bool?,
      shopifyPosterUrl: json['shopifyPosterUrl'] as String?,
      shopifyFileId: json['shopifyFileId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'previewShopifyFileId': previewShopifyFileId,
      'previewUrl': previewUrl,
      'posterUrl': posterUrl,
      'videoUrl': videoUrl,
      'hasOriginal': hasOriginal,
      'shopifyPosterUrl': shopifyPosterUrl,
      'shopifyFileId': shopifyFileId,
    };
  }
}
