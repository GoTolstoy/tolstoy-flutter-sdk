import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";

abstract class ProductsLoader {
  ProductsLoader({
    required this.appKey,
    required this.appUrl,
    required this.assets,
  });

  final String appKey;
  final String appUrl;
  final List<Asset> assets;

  Future<List<Product>> getProducts(Asset asset, SdkErrorCallback? onError);

  void preload(List<Asset> assets, SdkErrorCallback? onError);
}

typedef ProductsLoaderFactory = ProductsLoader Function({
  required String appKey,
  required String appUrl,
  required List<Asset> assets,
});
