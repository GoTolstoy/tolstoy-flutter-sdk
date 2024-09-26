import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/feed_product_card.dart';

class FeedProductListOptions {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry itemPadding;

  const FeedProductListOptions({
    this.backgroundColor = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 8),
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
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: options.itemPadding,
              child: FeedProductCard(
                product: product,
                onProductClick: onProductClick,
              ),
            );
          },
        ),
      ),
    );
  }
}