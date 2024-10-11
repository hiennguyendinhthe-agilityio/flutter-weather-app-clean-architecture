library;

import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:bazar_books_design/widgets/indicators/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class BazUiElevatedButton extends StatelessWidget {
  const BazUiElevatedButton({
    required this.text,
    this.isLoading = false,
    this.width = double.infinity,
    this.onPressed,
    this.style,
    super.key,
  });

  /// The Text that will be centered inside the button
  final String text;

  /// The boolean parameter defined which button state is Loading or not
  /// Default to false
  final bool isLoading;

  /// The width of Button
  final double width;

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  final ButtonStyle? style;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: 48.0.h,
      child: ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: isLoading
            ? const BazUiCircularProgressIndicator()
            : FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  text,
                ),
              ),
      ),
    );
  }
}
