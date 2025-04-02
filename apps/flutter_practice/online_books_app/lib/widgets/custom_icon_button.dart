import 'package:flutter/material.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:sizer/sizer.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineBlueGray => BoxDecoration(
        borderRadius: BorderRadius.circular(24.h),
        border: Border.all(
          color: appTheme.blueGray900,
          width: 1.h,
        ),
      );

  static BoxDecoration get none => BoxDecoration();
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child,
  });

  final Alignment? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: iconButtonWidget)
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: DecoratedBox(
          decoration: decoration ??
              BoxDecoration(
                color: appTheme.gray50,
                borderRadius: BorderRadius.circular(10.h),
                border: Border.all(
                  color: appTheme.gray40001,
                  width: 0.h,
                ),
              ),
          child: IconButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onTap,
            icon: child ?? Container(),
          ),
        ),
      );
}
