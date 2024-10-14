import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/product_card/feed_product_card.dart';

class FeedProductListOptions {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry itemPadding;
  final double itemHeight;

  const FeedProductListOptions({
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.symmetric(
        vertical: 24), // Changed to 24px padding top and bottom
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.itemHeight = 88,
  });
}

class FeedProductList extends StatelessWidget {
  final List<Product> products;
  final FeedProductListOptions options;
  final void Function(Product)? onProductClick;

  const FeedProductList({
    super.key,
    required this.products,
    this.options = const FeedProductListOptions(),
    this.onProductClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: options.backgroundColor,
      padding: options.padding,
      child: SizedBox(
        height: options.itemHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: options.itemPadding,
              child: FeedProductCard(
                product: product,
                options: FeedProductCardOptions(
                  height: options.itemHeight,
                  imageWidth: 88,
                ),
                onProductClick: onProductClick,
              ),
            );
          },
        ),
      ),
    );
  }
}
