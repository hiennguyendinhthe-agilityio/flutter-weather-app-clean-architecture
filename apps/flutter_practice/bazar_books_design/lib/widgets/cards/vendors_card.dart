import 'package:bazar_books_design/core/constant/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
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
        Container(
          decoration: BoxDecoration(
            color: const Color(0XFFF9F9F9),
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                child: imageUrl == null || (imageUrl?.isEmpty ?? false)
                    ? Image.network(
                        cacheWidth: 200,
                        cacheHeight: 200,
                        Constants.imgUrlDefault,
                        fit: BoxFit.fill,
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
            ],
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

class ListItemWidget extends StatelessWidget {
  final String? imageUrl;

  const ListItemWidget({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          child: imageUrl == null || (imageUrl?.isEmpty ?? false)
              ? Image.network(
                  cacheWidth: 200.0.w.toInt(),
                  cacheHeight: 200.0.h.toInt(),
                  Constants.imgUrlDefault,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  cacheWidth: 200,
                  cacheHeight: 200,
                  imageUrl!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
