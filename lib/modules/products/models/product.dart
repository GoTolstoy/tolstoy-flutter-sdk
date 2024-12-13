class Product {
  final String id;
  final String handle;
  final String title;
  final String imageUrl;
  final List<Variant> variants;
  final Map<String, dynamic> options;
  final List<ProductImage> images;
  final String? tags;
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
      id: json['id'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      variants: (json['variants'] as List?)
          ?.map((variant) => Variant.fromJson(variant as Map<String, dynamic>))
          .toList() ?? [],
      options: json['options'] as Map<String, dynamic>? ?? {},
      images: (json['images'] as List?)
          ?.map((image) => ProductImage.fromJson(image as Map<String, dynamic>))
          .toList() ?? [],
      tags: json['tags'] as String?,
      descriptionHtml: json['descriptionHtml'] as String?,
      templateSuffix: json['templateSuffix'] as String?,
      dbProductId: json['dbProductId'] as String? ?? '',
      appKey: json['appKey'] as String? ?? '',
      appUrl: json['appUrl'] as String? ?? '',
      currencyCode: json['currencyCode'] as String? ?? '',
      currencySymbol: json['currencySymbol'] as String? ?? '',
      yotpoReview: json['yotpo'] != null && (json['yotpo']['reviews'] as num?) != null
          ? YotpoReview.fromJson(json['yotpo'] as Map<String, dynamic>)
          : null,
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

  bool hasReviews() {
    return yotpoReview != null && yotpoReview!.reviews > 0;
  }
}

class ProductImage {
  final int id;
  final String src;

  ProductImage({required this.id, required this.src});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as int,
      src: json['src'] as String,
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
  final dynamic id;
  final dynamic price;
  final dynamic compareAtPrice;
  final String title;
  final Map<String, String?> selectedOptions;
  final bool isVariantAvailableForSale;
  final String? sku;

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
      productId: json['productId'] as String,
      id: json['id'],
      price: json['price'],
      compareAtPrice: json['compareAtPrice'],
      title: json['title'] as String,
      selectedOptions:
          Map.from(json['selectedOptions'] as Map<String, dynamic>),
      isVariantAvailableForSale: json['isVariantAvailableForSale'] as bool,
      sku: json['sku'] as String?,
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
      reviews: json['reviews'] as int,
      score: (json['score'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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
      final product = value as Map<String, dynamic>;
      
      // Skip products missing required fields
      if (product['id'] == null ||
          product['appKey'] == null ||
          product['dbProductId'] == null ||
          product['appUrl'] == null ||
          product['imageUrl'] == null ||
          product['title'] == null) {
        return;
      }

      try {
        productMap[key] = Product.fromJson(product);
      } catch (e) {
        // Skip products that fail to parse
        print('Failed to parse product: $e');
      }
    });
    return ProductsMap(products: productMap);
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((key, value) => MapEntry(key, value.toJson())),
    };
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
