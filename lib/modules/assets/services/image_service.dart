import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/constants.dart';
import 'package:tolstoy_flutter_sdk/core/config.dart';

const String _extension = '.webp';

class ImageService {
  static String getImageUrl(Asset asset, {AssetSize size = AssetSize.m}) {
    final route = '${AppConfig.baseUrl}/public/${asset.owner}/${asset.id}/';
    final fileName = '${asset.id}${getSuffix(size)}$_extension';

    return asset.stockAsset?.posterUrl ?? '$route$fileName';
  }

  static String getSuffix(AssetSize size) {
    switch (size) {
      case AssetSize.xs:
        return '_250';
      case AssetSize.s:
        return '_480';
      case AssetSize.m:
        return '_960';
      case AssetSize.l:
        return '_1280';
      case AssetSize.xl:
        return '_1920';
    }
  }
}
