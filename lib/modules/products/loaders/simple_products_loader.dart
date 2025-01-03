import "package:tolstoy_flutter_sdk/core/types.dart";
import "package:tolstoy_flutter_sdk/modules/api/services/api.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";

class SimpleProductsLoader extends ProductsLoader {
  SimpleProductsLoader({
    required super.appUrl,
    required super.appKey,
    required super.assets,
    this.disableCache = false,
  });

  final bool disableCache;
  final Map<String, List<Product>> _productsCache = {};
  final Map<String, Future<ProductsMap>> _futureProductsMapCache = {};

  @override
  Future<List<Product>> getProducts(
    Asset asset,
    SdkErrorCallback? onError,
  ) async {
    final cachedProducts = _productsCache[asset.id];

    if (cachedProducts != null) {
      return cachedProducts;
    }

    _futureProductsMapCache[asset.id] = _futureProductsMapCache[asset.id] ??
        ApiService.getProductsByVodAssetIds(
          [asset.id],
          appUrl,
          appKey,
          disableCache: disableCache,
          onError: onError,
        );

    final productsMap = await _futureProductsMapCache[asset.id];

    final products = asset.products
            ?.map((productRef) => productsMap?.getProductById(productRef.id))
            .whereType<Product>()
            .toList() ??
        [];

    _productsCache[asset.id] = products;

    return products;
  }

  @override
  void preload(List<Asset> assets, SdkErrorCallback? onError) {
    // Do not preload products in simple products loader
  }
}
