import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class BazUiOfferCard extends StatelessWidget {
  const BazUiOfferCard(
      {super.key,
      this.discount = '',
      this.imageUrl,
      this.width = double.infinity,
      this.borderRadius,
      this.onTap,
      this.height = 180});

  final String? discount;
  final String? imageUrl;
  final double width;
  final BorderRadiusGeometry? borderRadius;
  final Function()? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.onPrimary,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.bazS.specialOffer,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$discount%',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 16),
                    BazUiElevatedButton(
                      onPressed: onTap,
                      text: context.bazS.orderNow,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl == null || (imageUrl?.isEmpty ?? false)
                    ? Image.network(
                        Constants.imgUrlDefault,
                        fit: BoxFit.cover,
                        height: height,
                      )
                    : Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        height: height,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
