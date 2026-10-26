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
    this.mediaAsset,
  });

  factory Asset.fromStepJson(
    JsonMap json, {
    Map<String, MediaAsset>? mediaAssetsById,
  }) {
    final parse = JsonParser(
      location: "Asset",
      json: json,
    );

    const cast = Cast(location: "Asset");

    final stockAsset = parse.jsonMapOrNull("stockAsset");
    final externalProviderData = parse.jsonMapOrNull("externalProviderData");
    final id = parse.string("videoId");

    return Asset(
      owner: parse.string("videoOwner"),
      id: id,
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
      mediaAsset: mediaAssetsById?[id],
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
  final MediaAsset? mediaAsset;
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
    this.postUrl,
    this.provider,
  });

  factory ExternalProviderData.fromJson(JsonMap json) {
    final parse = JsonParser(
      location: "ExternalProviderData",
      json: json,
    );

    return ExternalProviderData(
      handle: parse.stringOrNull("handle"),
      postUrl: parse.stringOrNull("postUrl"),
      provider: parse.stringOrNull("provider"),
    );
  }

  final String? handle;
  final String? postUrl;
  final String? provider;
}

class MediaAsset {
  MediaAsset({
    this.sources = const {},
    this.preview = const {},
    this.poster = const {},
  });

  factory MediaAsset.fromJson(JsonMap json) {
    final parse = JsonParser(
      location: "MediaAsset",
      json: json,
    );

    return MediaAsset(
      sources: _urlsByWidth(parse.jsonMapOrNull("sources")),
      preview: _urlsByWidth(parse.jsonMapOrNull("preview")),
      poster: _urlsByWidth(parse.jsonMapOrNull("poster")),
    );
  }

  final Map<int, String> sources;
  final Map<int, String> preview;
  final Map<int, String> poster;

  String? sourceUrl(int width) => _urlForWidth(sources, width);

  String? previewUrl(int width) => _urlForWidth(preview, width);

  String? posterUrl(int width) => _urlForWidth(poster, width);

  static Map<int, String> _urlsByWidth(JsonMap? json) {
    final urls = <int, String>{};

    for (final entry in (json ?? {}).entries) {
      final key = entry.key;
      final url = entry.value;
      final width = key is String ? int.tryParse(key) : null;

      if (width != null && url is String) {
        urls[width] = url;
      }
    }

    return urls;
  }

  static String? _urlForWidth(Map<int, String> urls, int width) {
    if (urls.isEmpty) {
      return null;
    }

    final widths = urls.keys.toList()..sort();

    return urls[widths.firstWhere(
      (availableWidth) => availableWidth >= width,
      orElse: () => widths.last,
    )];
  }
}
