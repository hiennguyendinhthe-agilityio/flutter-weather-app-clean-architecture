import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/extensions/responsive_extension.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:flutter/material.dart';

class BazUiAuthor extends StatelessWidget {
  const BazUiAuthor({
    super.key,
    this.fullName,
    this.occupation = '',
    this.imageUrl,
    this.style,
  });

  final String? fullName;
  final String? occupation;
  final String? imageUrl;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: context.getWidgetSize(mobile: 60, tablet: 80),
            backgroundImage: NetworkImage(
              scale: 200,
              imageUrl ?? Constants.imgUrlDefault,
            ),
          ),
          SizedBox(height: context.getPadding(mobile: 10, tablet: 14)),
          Text(
            fullName ?? Constants.titleDefault,
            style: style ??
                context.textTheme.labelLarge?.copyWith(
                  fontSize: context.fontSize(SizeType.m),
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            occupation ?? Constants.titleDefault,
            style: style ??
                context.textTheme.labelMedium?.copyWith(
                  fontSize: context.fontSize(SizeType.s),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
