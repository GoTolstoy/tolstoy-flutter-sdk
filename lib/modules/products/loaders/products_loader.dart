import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

abstract class ProductsLoader {
  final String appKey;
  final String appUrl;
  final List<Asset> assets;

  ProductsLoader({
    required this.appKey,
    required this.appUrl,
    required this.assets,
  });

  Future<List<Product>> getProducts(Asset asset);

  void preload(List<Asset> assets);
}
