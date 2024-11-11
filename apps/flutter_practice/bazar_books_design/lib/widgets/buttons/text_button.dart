import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class BazUiTextButton extends StatelessWidget {
  const BazUiTextButton({
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
          alignment: Alignment.centerRight),
      onPressed: onPressed,
      child: Text(
        text,
        style: style ?? context.textTheme.bodySmall,
      ),
    );
  }
}
