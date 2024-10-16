import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
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
            radius: 40.0.r,
            backgroundImage: NetworkImage(
              scale: 200,
              imageUrl ?? Constants.imgUrlDefault,
            ),
          ),
          SizedBox(height: 8.0.h),
          Text(
            fullName ?? Constants.titleDefault,
            style: style ??
                context.textTheme.labelLarge?.copyWith(
                  fontSize: context.fontSize(SizeType.s),
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            occupation ?? Constants.titleDefault,
            style: style ??
                context.textTheme.labelMedium?.copyWith(
                  fontSize: context.fontSize(SizeType.xs),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
