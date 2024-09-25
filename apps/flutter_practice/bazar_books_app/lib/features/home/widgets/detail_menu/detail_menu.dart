import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:flutter/material.dart';

class DetailMenu extends StatefulWidget {
  const DetailMenu({required this.product, super.key});

  final Product product;

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 69),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.product.imageUrl ?? '',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  maxLines: 1,
                  widget.product.title ?? Constants.titleDefault,
                  style: context.textTheme.titleLarge,
                ),
                const Spacer(),
                BazUiIconButton(
                  icon: isFavorite
                      ? BazUiBuiltInImage.icLoveFill(
                          color: context.colorScheme.primary,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: context.colorScheme.primary,
                        ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              context.bazS.detailMenuGoodDayTitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(context.bazS.detailMenuDescription,
                style: context.textTheme.labelMedium),
            const SizedBox(height: 16),
            Text(
              context.bazS.reviewTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const StarRating(rating: 3),
            const SizedBox(height: 16),
            BazUiAmount(
              price: '\$${widget.product.price}',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: BazUiElevatedButton(
                    onPressed: () {},
                    text: context.bazS.continueButton,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BazUiElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith(
                        (Set<WidgetState> states) =>
                            context.colorScheme.primary,
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.disabled)) {
                          return context.colorScheme.secondaryContainer;
                        }

                        return context.colorScheme.onPrimary;
                      }),
                    ),
                    onPressed: () {},
                    text: context.bazS.viewButton,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
