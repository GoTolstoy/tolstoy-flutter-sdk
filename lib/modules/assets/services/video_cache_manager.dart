import "package:flutter_cache_manager/flutter_cache_manager.dart";

/// Disk cache for small `_preview.mp4` video clips.
///
/// Only preview clips are cached — full-resolution videos are large and stream
/// from the network. The cache is bounded so it stays small on disk.
class VideoPreviewCacheManager {
  VideoPreviewCacheManager._();

  static const String key = "tolstoyVideoPreviewCache";

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
    ),
  );

  /// Whether [url] points to a small Tolstoy-generated preview clip that is
  /// safe to cache on disk.
  static bool isCacheable(String url) => url.endsWith("_preview.mp4");
}
