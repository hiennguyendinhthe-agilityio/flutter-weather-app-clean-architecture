import 'package:flutter/material.dart';
import 'package:online_books_app/theme/custom_text_style.dart';
import 'package:online_books_app/theme/theme_helper.dart';

class AppbarSubtitle extends StatelessWidget {
  const AppbarSubtitle({
    super.key,
    required this.text,
    this.onTap,
    this.margin,
  });

  final String text;

  final Function()? onTap;

  final EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Text(
          text,
          style: CustomTextStyles.titleLargeDosisBluegray900
              .copyWith(color: appTheme.blueGray900),
        ),
      ),
    );
  }
}
