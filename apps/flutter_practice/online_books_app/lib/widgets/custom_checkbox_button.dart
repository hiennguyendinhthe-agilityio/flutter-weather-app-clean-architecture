import 'package:flutter/material.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/size_utils.dart';

// ignore_for_file: must_be_immutable
class CustomCheckboxButton extends StatelessWidget {
  CustomCheckboxButton(
      {super.key,
      required this.onChange,
      this.decoration,
      this.alignment,
      this.isRightCheck,
      this.iconSize,
      this.value,
      this.text,
      this.width,
      this.padding,
      this.textStyle,
      this.overflow,
      this.textAlignment,
      this.isExpandedText = false});

  final BoxDecoration? decoration;
  final Alignment? alignment;
  final bool? isRightCheck;
  final double? iconSize;
  bool? value;
  final Function(bool) onChange;
  final String? text;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextOverflow? overflow;
  final TextAlign? textAlignment;
  final bool isExpandedText;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildCheckBoxWidget,
          )
        : buildCheckBoxWidget;
  }

  Widget get buildCheckBoxWidget => GestureDetector(
        onTap: () {
          value = !(value!);
          onChange(value!);
        },
        child: Container(
          decoration: decoration,
          width: width,
          padding: padding,
          child: isRightCheck ?? false ? rightSideCheckBox : leftSideCheckBox,
        ),
      );

  Widget get leftSideCheckBox => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkboxWidget,
          SizedBox(
            width: text != null && text!.isNotEmpty ? 8.0 : 0,
          ),
          isExpandedText ? Expanded(child: textWidget) : textWidget,
        ],
      );

  Widget get rightSideCheckBox => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isExpandedText ? Expanded(child: textWidget) : textWidget,
          SizedBox(
            width: text != null && text!.isNotEmpty ? 8.0 : 0,
          ),
          checkboxWidget,
        ],
      );

  Widget get textWidget => Text(
        text ?? "Text",
        textAlign: textAlignment ?? TextAlign.start,
        overflow: overflow,
        style: textStyle ?? theme.textTheme.bodyLarge,
      );

  Widget get checkboxWidget => SizedBox(
        height: iconSize ?? 10.h,
        width: iconSize ?? 10.h,
        child: Checkbox(
          value: value ?? false,
          checkColor: theme.colorScheme.onPrimary,
          activeColor: theme.colorScheme.secondaryContainer,
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
          onChanged: (value) {
            onChange(value!);
          },
        ),
      );
}
