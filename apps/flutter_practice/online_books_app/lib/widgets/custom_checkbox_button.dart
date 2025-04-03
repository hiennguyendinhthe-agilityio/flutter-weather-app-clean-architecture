import 'package:flutter/material.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/size_utils.dart';

// ignore_for_file: must_be_immutable
class CustomCheckboxButton extends StatelessWidget {
  CustomCheckboxButton({
    super.key,
    required this.onChange,
    this.decoration,
    this.alignment,
    this.isRightCheck = false,
    this.iconSize,
    this.value = false,
    this.text,
    this.richText,
    this.width,
    this.padding,
    this.textStyle,
    this.overflow,
    this.textAlignment,
    this.isExpandedText = false,
    this.checkboxMargin,
  });

  final BoxDecoration? decoration;
  final Alignment? alignment;
  final bool isRightCheck;
  final double? iconSize;
  bool value;
  final Function(bool) onChange;
  final String? text;
  final InlineSpan? richText; // New parameter for rich text
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? checkboxMargin;
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
          onChange(!value);
        },
        child: Container(
          decoration: decoration,
          width: width,
          padding: padding,
          child: isRightCheck ? rightSideCheckBox : leftSideCheckBox,
        ),
      );

  Widget get leftSideCheckBox => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: checkboxMargin ?? EdgeInsets.only(top: 2),
            child: checkboxWidget,
          ),
          if (text != null || richText != null) ...[
            SizedBox(width: 8.h),
            isExpandedText ? Expanded(child: textContent) : textContent,
          ],
        ],
      );

  Widget get rightSideCheckBox => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isExpandedText ? Expanded(child: textContent) : textContent,
          SizedBox(width: 8.h),
          Container(
            margin: checkboxMargin ?? EdgeInsets.only(top: 2),
            child: checkboxWidget,
          ),
        ],
      );

  Widget get textContent {
    if (richText != null) {
      return RichText(
        text: richText!,
        textAlign: textAlignment ?? TextAlign.start,
        overflow: overflow ?? TextOverflow.visible,
      );
    }
    return Text(
      text ?? "",
      textAlign: textAlignment ?? TextAlign.start,
      overflow: overflow,
      style: textStyle ?? theme.textTheme.bodyLarge,
    );
  }

  Widget get checkboxWidget => SizedBox(
        height: iconSize ?? 20.h,
        width: iconSize ?? 20.w,
        child: Checkbox(
          value: value,
          checkColor: theme.colorScheme.onPrimary,
          activeColor: theme.colorScheme.secondaryContainer,
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (value) {
            onChange(value ?? false);
          },
        ),
      );
}
