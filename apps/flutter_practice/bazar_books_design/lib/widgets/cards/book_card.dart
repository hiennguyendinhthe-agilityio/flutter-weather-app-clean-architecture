import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class BazUiBookCard extends StatelessWidget {
  const BazUiBookCard({
    super.key,
    this.title,
    this.price,
    this.imageUrl,
    this.width = 120,
    this.height = 120,
    this.style,
    this.borderRadius,
    this.onTap,
  });
  final String? title;
  final String? price;
  final String? imageUrl;
  final double width;
  final double height;
  final TextStyle? style;
  final BorderRadiusGeometry? borderRadius;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: context.colorScheme.onPrimary,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        ),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
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
              const SizedBox(height: 10),
              Text(
                maxLines: 1,
                title ?? Constants.titleDefault,
                style: style ?? context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '\$$price',
                style: style ?? context.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
