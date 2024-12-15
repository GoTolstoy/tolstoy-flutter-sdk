import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

abstract class ProductsLoader {
  final String appKey;
  final String appUrl;

  ProductsLoader({
    required this.appKey,
    required this.appUrl,
  });

  Future<List<Product>> getProducts(Asset asset);
}
