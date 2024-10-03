class Product {
  final String id;
  final String handle;
  final String title;
  final String imageUrl;
  final List<Variant> variants;
  final Map<String, dynamic> options;
  final List<ProductImage> images;
  final String tags;
  final String? descriptionHtml;
  final String? templateSuffix;
  final String dbProductId;
  final String appKey;
  final String appUrl;
  final String currencyCode;
  final String currencySymbol;
  final YotpoReview? yotpoReview;

  Product({
    required this.id,
    required this.handle,
    required this.title,
    required this.imageUrl,
    required this.variants,
    required this.options,
    required this.images,
    required this.tags,
    this.descriptionHtml,
    this.templateSuffix,
    required this.dbProductId,
    required this.appKey,
    required this.appUrl,
    required this.currencyCode,
    required this.currencySymbol,
    this.yotpoReview,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      handle: json['handle'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      variants: (json['variants'] as List).map((v) => Variant.fromJson(v)).toList(),
      options: json['options'],
      images: (json['images'] as List).map((i) => ProductImage.fromJson(i)).toList(),
      tags: json['tags'],
      descriptionHtml: json['descriptionHtml'],
      templateSuffix: json['templateSuffix'],
      dbProductId: json['dbProductId'],
      appKey: json['appKey'],
      appUrl: json['appUrl'],
      currencyCode: json['currencyCode'],
      currencySymbol: json['currencySymbol'],
      yotpoReview: json['yotpo'] != null ? YotpoReview.fromJson(json['yotpo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handle': handle,
      'title': title,
      'imageUrl': imageUrl,
      'variants': variants.map((v) => v.toJson()).toList(),
      'options': options,
      'images': images.map((i) => i.toJson()).toList(),
      'tags': tags,
      'descriptionHtml': descriptionHtml,
      'templateSuffix': templateSuffix,
      'dbProductId': dbProductId,
      'appKey': appKey,
      'appUrl': appUrl,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'yotpo': yotpoReview?.toJson(),
    };
  }
}

class ProductImage {
  final int id;
  final String src;

  ProductImage({required this.id, required this.src});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      src: json['src'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'src': src,
    };
  }
}

class Variant {
  final String productId;
  final int id;
  final String? price;
  final String? compareAtPrice;
  final String title;
  final Map<String, String?> selectedOptions;
  final bool isVariantAvailableForSale;
  final String sku;

  Variant({
    required this.productId,
    required this.id,
    required this.price,
    this.compareAtPrice,
    required this.title,
    required this.selectedOptions,
    required this.isVariantAvailableForSale,
    required this.sku,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      productId: json['productId'],
      id: json['id'],
      price: json['price'],
      compareAtPrice: json['compareAtPrice'],
      title: json['title'],
      selectedOptions: Map<String, String?>.from(json['selectedOptions']),
      isVariantAvailableForSale: json['isVariantAvailableForSale'],
      sku: json['sku'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'id': id,
      'price': price,
      'compareAtPrice': compareAtPrice,
      'title': title,
      'selectedOptions': selectedOptions,
      'isVariantAvailableForSale': isVariantAvailableForSale,
      'sku': sku,
    };
  }
}

class YotpoReview {
  final int reviews;
  final double score;
  final DateTime updatedAt;

  YotpoReview({
    required this.reviews,
    required this.score,
    required this.updatedAt,
  });

  factory YotpoReview.fromJson(Map<String, dynamic> json) {
    return YotpoReview(
      reviews: json['reviews'],
      score: json['score'].toDouble(),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviews': reviews,
      'score': score,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ProductsMap {
  final Map<String, Product> products;

  ProductsMap({required this.products});

  factory ProductsMap.fromJson(Map<String, dynamic> json) {
    Map<String, Product> productMap = {};
    json.forEach((key, value) {
      if (value['imageUrl'] == null) {
        // skipping invalid products
        return;
      }

      productMap[key] = Product.fromJson(value);
    });
    return ProductsMap(products: productMap);
  }

  Product? getProductById(String dbProductId) {
    return products[dbProductId];
  }

  void addProduct(Product product) {
    products[product.dbProductId] = product;
  }

  void removeProduct(String dbProductId) {
    products.remove(dbProductId);
  }
}