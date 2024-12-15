import 'package:tolstoy_flutter_sdk/modules/api/services/api.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/loaders/products_loader.dart';
import 'package:tolstoy_flutter_sdk/modules/products/models.dart';

class BatchProductsLoader extends ProductsLoader {
  BatchProductsLoader({
    required super.appUrl,
    required super.appKey,
    required super.assets,
    this.minPreload = 1,
    this.maxPreload = 10,
  });

  final int minPreload;
  final int maxPreload;
  final Map<String, List<Product>> _productsCache = {};
  final Map<String, Future<ProductsMap>> _futureProductsMapCache = {};

  @override
  Future<List<Product>> getProducts(Asset asset) async {
    final assetIndex =
        assets.indexWhere((candidate) => candidate.id == asset.id);

    if (assetIndex == -1) {
      return [];
    }

    if (!_isSlicePreloading(_getMinSlice(assetIndex))) {
      _loadSlice(_getMaxSlice(assetIndex));
    }

    if (_productsCache.containsKey(asset.id)) {
      return _productsCache[asset.id]!;
    }

    final productsMap = await _futureProductsMapCache[asset.id];

    final products = asset.products
        .map((productRef) => productsMap!.getProductById(productRef.id))
        .where((product) => product != null)
        .cast<Product>()
        .toList();

    _productsCache[asset.id] = products;

    return products;
  }

  List<String> _getMinSlice(int assetIndex) {
    final startIndex = (assetIndex - minPreload).clamp(0, assets.length - 1);

    final endIndex = (assetIndex + minPreload + 1).clamp(0, assets.length);

    return assets.sublist(startIndex, endIndex).map((a) => a.id).toList();
  }

  List<String> _getMaxSlice(int assetIndex) {
    final startIndex = (assetIndex - maxPreload).clamp(0, assets.length - 1);

    final endIndex = (assetIndex + maxPreload + 1).clamp(0, assets.length);

    return assets.sublist(startIndex, endIndex).map((a) => a.id).toList();
  }

  bool _isSlicePreloading(List<String> slice) {
    return slice.every((id) => _futureProductsMapCache.containsKey(id));
  }

  void _loadSlice(List<String> slice) {
    final filteredSlice =
        slice.where((id) => !_futureProductsMapCache.containsKey(id)).toList();

    final futureProductsMap =
        ApiService.getProductsByVodAssetIds(filteredSlice, appUrl, appKey);

    for (final id in filteredSlice) {
      _futureProductsMapCache[id] = futureProductsMap;
    }
  }
}
