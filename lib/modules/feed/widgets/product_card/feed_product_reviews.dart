import "package:flutter/material.dart";
import "package:tolstoy_flutter_sdk/modules/products/models.dart";

class FeedProductReview extends StatelessWidget {
  const FeedProductReview({
    required this.review,
    super.key,
  });

  final YotpoReview review;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          StarRating(rating: review.score),
          const SizedBox(width: 4),
          Text(
            "(${review.reviews})",
            style: const TextStyle(fontSize: 12),
          ),
        ],
      );
}

class StarRating extends StatelessWidget {
  const StarRating({
    required this.rating,
    super.key,
  });

  final double rating;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          if (index < rating.floor()) {
            return const Icon(Icons.star, color: Color(0xFFEE610F), size: 16);
          } else if (index < rating.ceil() && rating % 1 != 0) {
            return const Icon(
              Icons.star_half,
              color: Color(0xFFEE610F),
              size: 16,
            );
          } else {
            return const Icon(
              Icons.star_border,
              color: Color(0xFFEE610F),
              size: 16,
            );
          }
        }),
      );
}
