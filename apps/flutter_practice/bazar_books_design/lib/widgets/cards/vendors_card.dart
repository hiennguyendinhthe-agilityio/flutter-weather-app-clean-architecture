import 'package:bazar_books_design/core/constant/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:flutter/material.dart';

class BazUiVendorCard extends StatelessWidget {
  const BazUiVendorCard({
    super.key,
    this.imageUrl,
    this.headlines = '',
    this.subheads,
    this.width = 100,
    this.height = 100,
    this.borderRadius,
    this.style,
  });

  final String? imageUrl;
  final String headlines;
  final Widget? subheads;
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            color: context.colorScheme.onPrimary,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: imageUrl == null || (imageUrl?.isEmpty ?? false)
                  ? Image.network(
                      cacheWidth: 200,
                      cacheHeight: 200,
                      Constants.imgUrlDefault,
                      fit: BoxFit.cover,
                      height: height,
                    )
                  : Image.network(
                      cacheWidth: 200,
                      cacheHeight: 200,
                      imageUrl!,
                      fit: BoxFit.cover,
                      height: height,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          headlines,
          style: style ??
              context.textTheme.bodyMedium?.copyWith(
                fontSize: context.fontSize(SizeType.s), // Font size responsive
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        subheads ?? const SizedBox.shrink(),
      ],
    );
  }
}
