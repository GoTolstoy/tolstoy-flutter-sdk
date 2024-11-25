import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/products/services.dart';

import 'feed_product_reviews.dart';

class FeedProductCardOptions {
  final double maxWidthFactor;
  final double height;
  final double borderRadius;
  final double imageWidth;
  final BoxFit imageFit;
  final Duration imageLoadDelay;

  const FeedProductCardOptions({
    this.maxWidthFactor = 0.75,
    this.height = 200,
    this.borderRadius = 8.0,
    this.imageWidth = 72,
    this.imageFit = BoxFit.cover,
    this.imageLoadDelay = Duration.zero,
  });
}

class FeedProductCard extends StatelessWidget {
  final Product product;
  final void Function(Product)? onProductClick;
  final FeedProductCardOptions options;

  const FeedProductCard({
    super.key,
    required this.product,
    this.onProductClick,
    this.options = const FeedProductCardOptions(),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onProductClick != null) {
          onProductClick!(product);
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
                  left: Radius.circular(options.borderRadius)),
              child: SizedBox(
                width: options.imageWidth,
                height: options.height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.grey[300]),
                    CachedNetworkImage(
                      imageUrl: ProductUtils.getOptimizedImageUrl(
                        product,
                        width: options.imageWidth.toInt(),
                      ),
                      fit: options.imageFit,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[300]),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Column(
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
                            maxLines: product.hasReviews() ? 1 : 2,
                          ),
                          if (product.hasReviews()) ...[
                            const SizedBox(height: 4),
                            FeedProductReview(review: product.yotpoReview!),
                          ],
                        ],
                      ),
                      Text(
                        ProductUtils.getProductPriceLabel(product) ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
