import "package:collection/collection.dart"; // needed for .firstWhereOrNull
import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/core/types.dart";

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

  static Widget getProductPriceLabel(
    Product product, {
    required PriceFormatter formatter,
    String? variantId,
  }) {
    final price = getProductPrice(product, variantId: variantId);
    if (price != null) {
      return formatter(price: price, currencySymbol: product.currencySymbol);
    }

    return const SizedBox.shrink();
  }

  static String getOptimizedImageUrl(
    String imageUrl, {
    int? width,
    int? height,
  }) {
    if (imageUrl.contains("cdn.shopify.com")) {
      return _optimizeShopifyImageUrl(imageUrl, width, height);
    }

    return imageUrl;
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
