import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class VendorCard extends StatelessWidget {
  const VendorCard({
    super.key,
    this.imageUrl = '',
    this.headlines = '',
    this.subheads,
    this.width = 100,
    this.height = 100,
    this.borderRadius,
    this.style,
  });
  final String imageUrl;
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
        Card(
          color: context.colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.network(
              imageUrl,
              width: width,
              height: height,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Title Section
        Text(
          headlines,
          style: style ?? context.textTheme.bodyMedium,
        ),
        subheads ?? const SizedBox.shrink(),
      ],
    );
  }
}
