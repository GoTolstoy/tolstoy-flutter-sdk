import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/constants.dart';
import 'package:tolstoy_flutter_sdk/core/config.dart';

class VideoService {
  static String getVideoUrl(Asset asset, {AssetSize size = AssetSize.m}) {
    final videoUrl = asset.stockAsset?.videoUrl;
    if (videoUrl != null) {
      return videoUrl;
    }

    return asset.uploadType.contains('aiVideo') ?  _getAiVideoUrl(asset, size) : _getVideoUrl(asset, size);
  }

  static String getPosterUrl(Asset asset) {
    final stockPosterUrl = asset.stockAsset?.posterUrl;
    if (stockPosterUrl != null) {
      return stockPosterUrl;
    }

    return '${AppConfig.baseUrl}/public/${asset.owner}/${asset.id}/${asset.id}.0000000.jpg';
  }

  static String _getVideoUrl(Asset asset, AssetSize size) {
    return '${AppConfig.baseUrl}/public/${asset.owner}/${asset.id}/${asset.id}${getSuffix(size)}.mp4';
  }

  static String _getAiVideoUrl(Asset asset, AssetSize size) {
    return '${AppConfig.baseUrl}/public/${asset.owner}/${asset.id}/${asset.id}_w_${getSuffix(size)}.mp4';
  }

  static String getSuffix(AssetSize size) {
    switch (size) {
      case AssetSize.xs:
      case AssetSize.s:
        return '_640';
      case AssetSize.m:
        return '_960';
      case AssetSize.l:
      case AssetSize.xl:
        return '';
    }
  }
}
