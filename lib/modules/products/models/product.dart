import "package:tolstoy_flutter_sdk/utils/cast.dart";
import "package:tolstoy_flutter_sdk/utils/json_parser.dart";
import "package:tolstoy_flutter_sdk/utils/types.dart";

class Product {
  Product({
    required this.dbId,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.currencySymbol,
    required this.variants,
    this.images,
    this.tags,
    this.dbProductId,
    this.appKey,
    this.appUrl,
    this.handle,
    this.currencyCode,
    this.descriptionHtml,
    this.templateSuffix,
    this.yotpoReview,
  });

  factory Product.fromJsonUnsafe(String dbId, JsonMap json) {
    final parse = JsonParser(
      location: "Product",
      json: json,
    );

    const cast = Cast(location: "Product");

    final yotpo = parse.jsonMapOrNull("yotpo");

    return Product(
      dbId: dbId,
      id: parse.string("id"),
      title: parse.string("title"),
      imageUrl: parse.string("imageUrl"),
      currencySymbol: parse.string("currencySymbol"),
      variants: parse.list(
        "variants",
        (variant) => Variant.fromJson(
          cast.jsonMap(variant, "variants::variant"),
        ),
      ),
      images: parse.listOrNull(
        "images",
        (image) => ProductImage.fromJson(
          cast.jsonMap(image, "images::image"),
        ),
      ),
      tags: parse.stringOrNull("tags"),
      dbProductId: parse.stringOrNull("dbProductId"),
      appKey: parse.stringOrNull("appKey"),
      appUrl: parse.stringOrNull("appUrl"),
      handle: parse.stringOrNull("handle"),
      currencyCode: parse.stringOrNull("currencyCode"),
      descriptionHtml: parse.stringOrNull("descriptionHtml"),
      templateSuffix: parse.stringOrNull("templateSuffix"),
      yotpoReview: yotpo != null ? YotpoReview.fromJson(yotpo) : null,
    );
  }

  final String dbId;
  final String id;
  final String title;
  final String imageUrl;
  final String currencySymbol;
  final List<Variant> variants;
  final List<ProductImage>? images;
  final String? tags;
  final String? dbProductId;
  final String? appKey;
  final String? appUrl;
  final String? handle;
  final String? currencyCode;
  final String? descriptionHtml;
  final String? templateSuffix;
  final YotpoReview? yotpoReview;

  static bool isConvertable(JsonMap json) =>
      json["id"] != null &&
      json["title"] != null &&
      json["imageUrl"] != null &&
      json["currencySymbol"] != null &&
      json["variants"] != null;

  static Product? fromJson(String dbId, JsonMap json) =>
      isConvertable(json) ? Product.fromJsonUnsafe(dbId, json) : null;

  JsonMap toJson() => {
        "id": id,
        "title": title,
        "imageUrl": imageUrl,
        "currencySymbol": currencySymbol,
        "variants": variants.map((variant) => variant.toJson()).toList(),
        "images": images?.map((image) => image.toJson()).toList(),
        "tags": tags,
        "dbProductId": dbProductId,
        "appKey": appKey,
        "appUrl": appUrl,
        "handle": handle,
        "currencyCode": currencyCode,
        "descriptionHtml": descriptionHtml,
        "templateSuffix": templateSuffix,
        "yotpo": yotpoReview?.toJson(),
      };
}

class ProductImage {
  ProductImage({
    required this.id,
    required this.src,
  });

  factory ProductImage.fromJson(JsonMap json) {
    final parse = JsonParser(
      location: "ProductImage",
      json: json,
    );

    return ProductImage(
      id: parse.integer("id"),
      src: parse.string("src"),
    );
  }

  final int id;
  final String src;

  JsonMap toJson() => {
        "id": id,
        "src": src,
      };
}

class Variant {
  Variant({
    required this.id,
    required this.price,
    this.imageUrl,
    this.compareAtPrice,
    this.title,
    this.productId,
    this.isVariantAvailableForSale,
    this.sku,
  });

  factory Variant.fromJson(JsonMap json) {
    final parse = JsonParser(
      location: "Variant",
      json: json,
    );

    return Variant(
      id: parse.string("id"),
      price: parse.string("price"),
      imageUrl: parse.stringOrNull("imageUrl"),
      compareAtPrice: parse.stringOrNull("compareAtPrice"),
      title: parse.stringOrNull("title"),
      productId: parse.stringOrNull("productId"),
      isVariantAvailableForSale:
          parse.booleanOrNull("isVariantAvailableForSale"),
      sku: parse.stringOrNull("sku"),
    );
  }

  final String id;
  final String price;
  final String? imageUrl;
  final String? compareAtPrice;
  final String? title;
  final String? productId;
  final bool? isVariantAvailableForSale;
  final String? sku;

  JsonMap toJson() => {
        "id": id,
        "price": price,
        "imageUrl": imageUrl,
        "productId": productId,
        "compareAtPrice": compareAtPrice,
        "title": title,
        "isVariantAvailableForSale": isVariantAvailableForSale,
        "sku": sku,
      };
}

class YotpoReview {
  YotpoReview({
    required this.reviews,
    required this.score,
    this.updatedAt,
  });

  factory YotpoReview.fromJson(JsonMap json) {
    final parse = JsonParser(
      location: "YotpoReview",
      json: json,
    );

    return YotpoReview(
      reviews: parse.integer("reviews"),
      score: parse.doubleValue("score"),
      updatedAt: parse.dateTimeOrNull("updatedAt"),
    );
  }

  final int reviews;
  final double score;
  final DateTime? updatedAt;

  JsonMap toJson() => {
        "reviews": reviews,
        "score": score,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class ProductsMap {
  ProductsMap({required this.products});

  factory ProductsMap.fromJson(JsonMap json) {
    final productMap = <String, Product>{};

    const cast = Cast(location: "ProductsMap");

    json.forEach((key, value) {
      if (key is! String) {
        return;
      }

      final productJson = cast.jsonMapOrNull(value, key);

      if (productJson == null) {
        return;
      }

      final product = Product.fromJson(key, productJson);

      if (product == null) {
        return;
      }

      productMap[key] = product;
    });

    return ProductsMap(products: productMap);
  }

  final Map<String, Product> products;

  Product? getProductById(String dbProductId) => products[dbProductId];
}
