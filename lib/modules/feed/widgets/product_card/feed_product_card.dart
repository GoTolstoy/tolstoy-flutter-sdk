import "package:cached_network_image/cached_network_image.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/api/models/tv_page_client_config.dart";
import "package:tolstoy_flutter_sdk/modules/assets/models/asset.dart";
import "package:tolstoy_flutter_sdk/modules/feed/widgets/product_card/feed_product_reviews.dart";
import "package:tolstoy_flutter_sdk/modules/products/services.dart";
import "package:tolstoy_flutter_sdk/tolstoy_flutter_sdk.dart";

class FeedProductCardOptions {
  const FeedProductCardOptions({
    this.maxWidthFactor = 0.75,
    this.height = 200,
    this.borderRadius = 8.0,
    this.imageWidth = 72,
    this.imageFit = BoxFit.cover,
    this.imageLoadDelay = Duration.zero,
  });

  final double maxWidthFactor;
  final double height;
  final double borderRadius;
  final double imageWidth;
  final BoxFit imageFit;
  final Duration imageLoadDelay;
}

class FeedProductCard extends StatelessWidget {
  const FeedProductCard({
    required this.asset,
    this.clientConfig = const TvPageClientConfig(),
    this.product,
    super.key,
    this.onProductClick,
    this.options = const FeedProductCardOptions(),
  });

  final Product? product;
  final void Function(Product)? onProductClick;
  final FeedProductCardOptions options;
  final Asset asset;
  final TvPageClientConfig clientConfig;

  @override
  Widget build(BuildContext context) {
    final localProduct = product;
    final taggedProducts = asset.products;
    final taggedProduct = localProduct != null && taggedProducts != null
        ? taggedProducts.firstWhereOrNull((p) => p.id == localProduct.dbId)
        : null;
    final taggedVariantIds = taggedProduct?.variantIds;
    final variant = localProduct != null && taggedVariantIds != null
        ? localProduct.variants
            .firstWhereOrNull((v) => taggedVariantIds.contains(v.id))
        : null;
    final imageUrl = variant?.imageUrl ?? localProduct?.imageUrl;

    return GestureDetector(
      onTap: () {
        if (localProduct != null) {
          onProductClick?.call(localProduct);
        }
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * options.maxWidthFactor,
          maxHeight: options.height,
        ),
        height: options.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(options.borderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(options.borderRadius),
              ),
              child: SizedBox(
                width: options.imageWidth,
                height: options.height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    clientConfig.loadingPlaceholderWidget,
                    if (imageUrl != null)
                      CachedNetworkImage(
                        imageUrl: ProductUtils.getOptimizedImageUrl(
                          imageUrl,
                          width: options.imageWidth.toInt(),
                        ),
                        fit: options.imageFit,
                        placeholder: (context, url) => const SizedBox.shrink(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.broken_image_rounded,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: options.height,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: localProduct != null
                      ? _buildProductCard(localProduct)
                      : _buildProductCardSkeleton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final yotpoReview = product.yotpoReview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: yotpoReview != null && yotpoReview.reviews > 0 ? 1 : 2,
            ),
            if (yotpoReview != null && yotpoReview.reviews > 0) ...[
              const SizedBox(height: 4),
              FeedProductReview(review: yotpoReview),
            ],
          ],
        ),
        ProductUtils.getProductPriceLabel(
          product,
          formatter: clientConfig.priceFormatter ??
              ({
                required String price,
                required String currencySymbol,
              }) =>
                  Text(
                    "$currencySymbol$price",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildProductCardSkeleton() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 0.04 * options.height),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 0.15 * options.height,
                  width: double.infinity,
                  child: clientConfig.loadingPlaceholderWidget,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 0.15 * options.height,
                  width: double.infinity,
                  child: clientConfig.loadingPlaceholderWidget,
                ),
              ),
            ],
          ),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 0.15 * options.height,
                  width: 50,
                  child: clientConfig.loadingPlaceholderWidget,
                ),
              ),
              SizedBox(height: 0.06 * options.height),
            ],
          ),
        ],
      );
}
