import 'package:flutter/material.dart';
import 'package:online_books_app/theme/theme_helper.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({super.key, required this.text, this.onTap, this.margin});

  final String text;
  final VoidCallback? onTap;
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
          style: theme.textTheme.headlineSmall!.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
