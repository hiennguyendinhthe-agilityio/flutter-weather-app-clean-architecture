library;

import 'package:flutter/material.dart';

class BazUiIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BoxBorder? border;
  final bool isCircular;

  const BazUiIconButton({
    /// The icon to display inside the [IconButton].
    required this.icon,
    this.onPressed,
    this.style,
    this.width,
    this.height,
    this.backgroundColor,
    this.border,
    this.isCircular = false,
    super.key,
  });

  /// Factory constructor for creating a circular icon button.
  factory BazUiIconButton.circular({
    required Widget icon,
    VoidCallback? onPressed,
    ButtonStyle? style,
    Color? backgroundColor,
    Color? borderColor,
    BoxBorder? border,
    double size = 40.0,
    Key? key,
  }) {
    return BazUiIconButton(
      icon: icon,
      onPressed: onPressed,
      style: style,
      width: size,
      height: size,
      backgroundColor: backgroundColor,
      border: border ??
          Border.all(
            color: borderColor ?? Colors.transparent,
          ),
      isCircular: true,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        border: border,
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        style: style,
        padding: EdgeInsets.zero,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
    );
  }
}
