import 'package:flutter/material.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/theme/custom_text_style.dart';
import 'package:online_books_app/widgets/base_button.dart';

class CustomOutlinedButton extends BaseButton {
  const CustomOutlinedButton({
    super.key,
    super.onPressed,
    required super.text,
    super.buttonTextStyle,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.lable,
    super.buttonStyle,
    TextStyle? textStyle,
    super.isDisabled,
    super.alignment,
    super.width,
    super.height,
    super.margin,
  });

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Widget? lable;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildOutLinedButtonWidget)
        : buildOutLinedButtonWidget;
  }

  Widget get buildOutLinedButtonWidget => Container(
        height: height ?? 36.h,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: OutlinedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                style: buttonTextStyle ?? CustomTextStyles.titleLargeGray50,
              ),
              rightIcon ?? const SizedBox.shrink(),
            ],
          ),
        ),
      );
}
