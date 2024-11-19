import 'package:tolstoy_flutter_sdk/modules/assets/constants/asset_type.dart';

class Asset {
  final List<ProductReference> products;
  final String name;
  final String owner;
  final String id;
  final StockAsset? stockAsset;
  final DateTime createdAt;
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

  factory Asset.fromStepJson(json) {
    AssetType type = AssetType.values.firstWhere(
      (e) => e.toString() == 'AssetType.${json['type'] ?? 'video'}',
      orElse: () => AssetType.video,
    );

    return Asset(
      id: json['videoId'],
      name: json['videoName'],
      owner: json['videoOwner'],
      uploadType: json['uploadType'],
      type: type,
      createdAt: DateTime.parse(json['videoCreatedAt']),
      stockAsset: json['stockAsset'] != null
          ? StockAsset.fromJson(json['stockAsset'])
          : null,
      products: (json['products'] as List?)
              ?.map((product) => ProductReference.fromJson(product))
              .toList() ??
          [],
    );
  }
}

class ProductReference {
  final String id;
  final List<String>? variantIds;

  ProductReference({required this.id, this.variantIds});

  factory ProductReference.fromJson(Map<String, dynamic> json) {
    return ProductReference(
      id: json['id'],
      variantIds: (json['variantIds'] as List?)?.cast<String>(),
    );
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
      previewShopifyFileId: json['previewShopifyFileId'],
      previewUrl: json['previewUrl'],
      posterUrl: json['posterUrl'],
      videoUrl: json['videoUrl'],
      hasOriginal: json['hasOriginal'],
      shopifyPosterUrl: json['shopifyPosterUrl'],
      shopifyFileId: json['shopifyFileId'],
    );
  }
}
