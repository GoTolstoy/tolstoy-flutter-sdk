import "package:tolstoy_flutter_sdk/core/config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/constants.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models.dart";

const String _extension = ".webp";

class ImageService {
  static String getImageUrl(Asset asset, {AssetSize size = AssetSize.m}) {
    final route =
        "${AppConfig.videoBaseUrl}/public/${asset.owner}/${asset.id}/";
    final fileName = "${asset.id}${getSuffix(size)}$_extension";

    return asset.stockAsset?.posterUrl ??
        asset.mediaAsset?.sourceUrl(getWidth(size)) ??
        "$route$fileName";
  }

  static String getSuffix(AssetSize size) => "_${getWidth(size)}";

  static int getWidth(AssetSize size) {
    switch (size) {
      case AssetSize.xs:
        return 250;
      case AssetSize.s:
        return 480;
      case AssetSize.m:
        return 960;
      case AssetSize.l:
        return 1280;
      case AssetSize.xl:
        return 1920;
    }
  }
}
