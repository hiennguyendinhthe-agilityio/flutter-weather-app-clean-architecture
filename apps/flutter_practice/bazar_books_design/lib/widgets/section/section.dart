import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/buttons/text_button.dart';
import 'package:flutter/material.dart';

class BazUiSection extends StatelessWidget {
  const BazUiSection({
    super.key,
    required this.title,
    required this.onSeeAllPressed,
    this.text = '',
  });

  final String title;
  final VoidCallback onSeeAllPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.textTheme.titleMedium),
        BazUiTextButton(
          onSeeAllPressed: onSeeAllPressed,
          text: text,
        ),
      ],
    );
  }
}
