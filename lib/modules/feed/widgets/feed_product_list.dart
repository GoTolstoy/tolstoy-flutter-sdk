import 'package:flutter/material.dart';

import 'package:tolstoy_flutter_sdk/modules/products/models.dart';
import 'package:tolstoy_flutter_sdk/modules/feed/widgets/product_card/feed_product_card.dart';

class FeedProductListOptions {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry itemPadding;
  final double itemHeight;
  final double imageWidth;

  const FeedProductListOptions({
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.symmetric(vertical: 24),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.itemHeight = 88,
    this.imageWidth = 88,
  });
}

class FeedProductList extends StatefulWidget {
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
  State<FeedProductList> createState() => _FeedProductListState();
}

class _FeedProductListState extends State<FeedProductList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.options.backgroundColor,
      padding: widget.options.padding,
      child: SizedBox(
        height: widget.options.itemHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final product = widget.products[index];
            return Padding(
              padding: widget.options.itemPadding,
              child: FeedProductCard(
                product: product,
                options: FeedProductCardOptions(
                  height: widget.options.itemHeight,
                  imageWidth: widget.options.imageWidth,
                  imageLoadDelay:
                      Duration(milliseconds: (200 * index).clamp(0, 500)),
                ),
                onProductClick: widget.onProductClick,
              ),
            );
          },
        ),
      ),
    );
  }
}
