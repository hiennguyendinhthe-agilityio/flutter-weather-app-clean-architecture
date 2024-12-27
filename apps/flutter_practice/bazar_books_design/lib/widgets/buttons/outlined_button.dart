import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:flutter/material.dart';

class BazUiOutLinedButton extends StatefulWidget {
  const BazUiOutLinedButton({
    required this.text,
    this.isLoading = false,
    this.width = double.infinity,
    this.onPressed,
    this.icon,
    super.key,
  });

  /// Factory constructor for BazUiOutLinedButton with an icon.
  factory BazUiOutLinedButton.icon({
    required String text,
    required Widget icon,
    bool isLoading = false,
    double width = double.infinity,
    EdgeInsetsGeometry? padding,
    VoidCallback? onPressed,
    Key? key,
  }) {
    return BazUiOutLinedButton(
      text: text,
      icon: icon,
      isLoading: isLoading,
      width: width,
      onPressed: onPressed,
      key: key,
    );
  }

  /// The Text that will be centered inside the button
  final String text;

  /// The boolean parameter defined which button state is Loading or not
  /// Default to false
  final bool isLoading;

  /// The width of Button
  ///
  /// The padding of [BazUiOutLinedButton] is
  /// * vertical: 10
  /// * horizontal: 24
  final double width;

  /// Icon displayed next to the text.
  final Widget? icon;

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  @override
  State<BazUiOutLinedButton> createState() => _BazUiOutLinedButtonState();
}

class _BazUiOutLinedButtonState extends State<BazUiOutLinedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.buttonSize(SizeType.s),
      width: widget.width.w,
      child: OutlinedButton(
        onPressed: widget.onPressed,
        child: widget.isLoading
            ? const BazUiCircularProgressIndicator()
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      widget.icon!,
                      SizedBox(width: 16.0.w),
                    ],
                    Text(
                      widget.text,
                      maxLines: 1,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
