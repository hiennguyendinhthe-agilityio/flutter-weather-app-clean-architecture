import 'package:flutter/material.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/data/models/selection_popup_model.dart';
import 'package:online_books_app/theme/theme_helper.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.width,
      this.alignment,
      this.boxDecoration,
      this.focusNode,
      this.icon,
      this.iconSize,
      this.autofocus = false,
      this.textStyle,
      this.hintText,
      this.hintStyle,
      this.items,
      this.prefix,
      this.prefixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.validator,
      this.onChanged});

  final Alignment? alignment;

  final double? width;

  final BoxDecoration? boxDecoration;

  final FocusNode? focusNode;

  final Widget? icon;

  final double? iconSize;

  final bool? autofocus;

  final TextStyle? textStyle;

  final String? hintText;

  final TextStyle? hintStyle;

  final List<SelectionPopupModel>? items;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<SelectionPopupModel>? validator;

  final Function(SelectionPopupModel)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: dropDownWidget,
          )
        : dropDownWidget;
  }

  Widget get dropDownWidget => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: DropdownButtonFormField<SelectionPopupModel>(
          focusNode: focusNode,
          icon: icon,
          iconSize: iconSize ?? 24,
          autofocus: autofocus!,
          style: textStyle ?? theme.textTheme.bodyLarge,
          hint: Text(
            hintText ?? "",
            style: hintStyle ?? theme.textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
          items: items?.map((SelectionPopupModel item) {
            return DropdownMenuItem<SelectionPopupModel>(
              value: item,
              child: Text(
                item.title,
                style: hintStyle ?? theme.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          decoration: decoration,
          validator: validator,
          onChanged: (value) {
            onChanged?.call(value!);
          },
        ),
      );

  InputDecoration get decoration => InputDecoration(
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        isDense: true,
        contentPadding:
            contentPadding ?? EdgeInsets.fromLTRB(8.h, 12.h, 12.h, 12.h),
        filled: filled,
        fillColor: fillColor ?? theme.colorScheme.onPrimary,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(
                color: appTheme.gray400,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(
                color: appTheme.gray400,
                width: 1,
              ),
            ),
        focusedBorder: (borderDecoration ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.h),
                ))
            .copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
      );
}
