import 'package:collection/collection.dart'; // needed for .firstWhereOrNull 

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

class ProductUtils {
  static String? getProductPrice(Product product, {String? variantId}) {
    // Extract the price from the first variant if no variantId is provided
    String? price =
        product.variants.isNotEmpty ? product.variants[0].price : null;

    if (variantId == null) {
      return price;
    }

    // Find the variant with the matching id
    Variant? variant =
        product.variants.firstWhereOrNull((v) => v.id.toString() == variantId);

    // Return the price of the found variant or the default price
    return variant?.price ?? price;
  }

  static String? getProductPriceLabel(Product product, {String? variantId}) {
    String? price = getProductPrice(product, variantId: variantId);
    if (price != null) {
      return '${product.currencySymbol}$price';
    }
    return null;
  }
}
