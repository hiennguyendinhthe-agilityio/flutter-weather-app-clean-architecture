import 'package:flutter/material.dart';
import 'package:online_books_app/core/app_export.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    this.text = '',
    this.style,
  });

  final VoidCallback onPressed;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
          alignment: Alignment.center),
      onPressed: onPressed,
      child: Text(
        text,
        style: style ?? context.textTheme.bodySmall,
      ),
    );
  }
}
