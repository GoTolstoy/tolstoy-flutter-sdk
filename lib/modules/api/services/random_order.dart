import "dart:math";

import "package:tolstoy_flutter_sdk/modules/assets/models.dart";
import "package:uuid/uuid.dart";

/// A seed generated once per app launch, so a "random order" feed keeps a stable order within a
/// session but differs across devices and restarts.
final String tvFeedShuffleSeed = const Uuid().v4();

/// Shuffles a "random order" feed client-side, mirroring the storefront web randomizer.
///
/// The feed config is served from a shared CDN cache (identical bytes for every device), so the
/// order is randomized here rather than on the server. Seeding by a per-launch value keeps the
/// order stable within a session while differing across devices and app restarts.
/// Pinned steps keep their original positions; only the rest are shuffled into the gaps.
List<Asset> shuffleAssetsWithSeed(
  List<Asset> assets,
  List<String> pinnedStepIds,
  String seed,
) {
  if (assets.length <= 1) {
    return assets;
  }

  final pinned = pinnedStepIds.toSet();
  final movable = assets.where((asset) => !pinned.contains(asset.id)).toList();

  if (movable.length <= 1) {
    return assets;
  }

  movable.shuffle(Random(seed.hashCode));

  var next = 0;
  return assets
      .map((asset) => pinned.contains(asset.id) ? asset : movable[next++])
      .toList();
}
