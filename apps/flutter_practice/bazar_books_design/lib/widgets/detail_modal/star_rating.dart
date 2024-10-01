import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/images/image.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.numberStar,
  });

  final int rating;
  final int maxStars;
  final Widget? numberStar;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          Row(
            children: List.generate(maxStars, (index) {
              return index < rating
                  ? BazUiBuiltInImage.icStar(
                      color: context.colorScheme.onTertiary,
                    )
                  : BazUiBuiltInImage.icStar(
                      color: context.colorScheme.onSecondaryContainer,
                    );
            }),
          ),
          const SizedBox(width: 8),
          numberStar ??
              Text(
                '(${rating.toStringAsFixed(1)})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ],
      ),
    );
  }
}
