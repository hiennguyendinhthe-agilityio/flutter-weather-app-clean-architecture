import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class BazUiEmpty extends StatelessWidget {
  const BazUiEmpty({
    super.key,
    this.imageEmpty,
    this.icon,
    this.message = '',
    this.onPressed,
    this.iconSize = 50,
  });

  final Widget? imageEmpty;
  final IconData? icon;
  final String message;
  final VoidCallback? onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageEmpty ??
              Icon(
                icon ?? Icons.info_outline,
                size: iconSize,
                color: Theme.of(context).colorScheme.tertiary,
              ),
          const SizedBox(height: 20),
          Text(
            message.isNotEmpty ? message : context.bazS.generalListEmpty,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onPressed != null)
            BazUiIconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
    );
  }
}
