import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Card(
          color: context.colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl == null || (imageUrl?.isEmpty ?? false)
                    ? Image.network(
                        cacheWidth: 127.0.w.toInt(),
                        cacheHeight: 150.0.h.toInt(),
                        Constants.imgUrlDefault,
                        fit: BoxFit.cover,
                        height: height,
                      )
                    : Image.network(
                        cacheWidth: 127.0.w.toInt(),
                        cacheHeight: 150.0.h.toInt(),
                        imageUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                title ?? Constants.titleDefault,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: context.fontSize(SizeType.s),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '\$$price',
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: context.fontSize(SizeType.s),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
