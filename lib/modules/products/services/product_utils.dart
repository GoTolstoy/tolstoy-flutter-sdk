import "package:collection/collection.dart"; // needed for .firstWhereOrNull

import "package:tolstoy_flutter_sdk/modules/products/models.dart";

class ProductUtils {
  static String? getUnformatedProductPrice(
    Product product, {
    String? variantId,
  }) {
    // Extract the price from the first variant if no variantId is provided
    final price =
        product.variants.isNotEmpty ? product.variants[0].price : null;

    if (variantId == null) {
      return price;
    }

    // Find the variant with the matching id
    final variant = product.variants.firstWhereOrNull((v) => v.id == variantId);

    // Return the price of the found variant or the default price
    return variant?.price ?? price;
  }

  static String? getProductPrice(Product product, {String? variantId}) {
    var price = getUnformatedProductPrice(product, variantId: variantId);

    if (price != null) {
      if (price.endsWith(".00") || price.endsWith(",00")) {
        price = price.substring(0, price.length - 3);
      }
    }

    return price;
  }

  static String? getProductPriceLabel(Product product, {String? variantId}) {
    final price = getProductPrice(product, variantId: variantId);
    if (price != null) {
      return "${product.currencySymbol}$price";
    }
    return null;
  }

  static String getOptimizedImageUrl(
    Product product, {
    int? width,
    int? height,
  }) {
    final originalUrl = product.imageUrl;

    if (originalUrl.contains("cdn.shopify.com")) {
      return _optimizeShopifyImageUrl(originalUrl, width, height);
    }

    return originalUrl;
  }

  static String _optimizeShopifyImageUrl(String url, int? width, int? height) {
    final uri = Uri.parse(url);
    final queryParams = <String, String>{};

    if (width != null) {
      queryParams["width"] = width.toString();
    }

    if (height != null) {
      queryParams["height"] = height.toString();
    }

    if (queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }

    return url;
  }
}
