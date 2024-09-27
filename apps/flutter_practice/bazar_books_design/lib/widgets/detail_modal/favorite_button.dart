import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BazUiIconButton(
      icon: isFavorite
          ? BazUiBuiltInImage.icLoveFill(
              color: context.colorScheme.primary,
            )
          : Icon(
              Icons.favorite_border,
              color: context.colorScheme.primary,
            ),
      onPressed: onPressed,
    );
  }
}
