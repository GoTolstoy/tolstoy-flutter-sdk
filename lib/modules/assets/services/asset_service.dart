import 'package:tolstoy_flutter_sdk/modules/assets/models.dart';
import 'package:tolstoy_flutter_sdk/modules/assets/constants.dart';
import 'image_service.dart';
import 'video_service.dart';

class AssetService {
  static String getAssetUrl(Asset asset, {AssetSize size = AssetSize.m}) {
    switch (asset.type) {
      case AssetType.image:
        return ImageService.getImageUrl(asset, size: size);
      case AssetType.video:
        return VideoService.getVideoUrl(asset, size: size);
    }
  }

  static String getPosterUrl(Asset asset, {AssetSize size = AssetSize.m}) {
    switch (asset.type) {
      case AssetType.image:
        return ImageService.getImageUrl(asset, size: size);
      case AssetType.video:
        return VideoService.getPosterUrl(asset);
    }
  }
}
