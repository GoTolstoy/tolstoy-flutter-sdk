import 'package:tolstoy_flutter_sdk/modules/api/services/api.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

class SimpleProductsLoader extends ProductsLoader {
  SimpleProductsLoader({
    required super.appUrl,
    required super.appKey,
    required super.assets,
  });

  final Map<String, List<Product>> _productsCache = {};
  final Map<String, Future<ProductsMap>> _futureProductsMapCache = {};

  @override
  Future<List<Product>> getProducts(Asset asset) async {
    if (_productsCache.containsKey(asset.id)) {
      return _productsCache[asset.id]!;
    }

    _futureProductsMapCache[asset.id] = _futureProductsMapCache[asset.id] ??
        ApiService.getProductsByVodAssetIds([asset.id], appUrl, appKey);

    final productsMap = await _futureProductsMapCache[asset.id];

    final products = asset.products
        .map((productRef) => productsMap!.getProductById(productRef.id))
        .where((product) => product != null)
        .cast<Product>()
        .toList();

    _productsCache[asset.id] = products;

    return products;
  }

  @override
  void preload(List<Asset> assets) {
    // Do not preload products in simple products loader
  }
}
