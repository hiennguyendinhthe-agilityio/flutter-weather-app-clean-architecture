import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/buttons/icon_button.dart';
import 'package:bazar_books_design/widgets/images/image.dart';
import 'package:flutter/material.dart';

class BazUiAmount extends StatelessWidget {
  const BazUiAmount({
    super.key,
    required this.amount,
    this.onIncrement,
    this.onDecrement,
    this.price = '',
  });

  final int amount;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final String price;

  @override
  Widget build(BuildContext context) {
    final double parsedPrice = double.tryParse(price) ?? 0.0;

    return Row(
      children: [
        Card(
          color: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              BazUiIconButton(
                onPressed: onDecrement,
                icon: BazUiBuiltInImage.icLess(),
              ),
              Text(
                amount.toString(),
                style: const TextStyle(fontSize: 16),
              ),
              BazUiIconButton(
                onPressed: onIncrement,
                icon: BazUiBuiltInImage.icAdd(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '\$${(parsedPrice * amount).toStringAsFixed(2)}',
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}
