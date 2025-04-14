import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/data/models/selection_popup_model.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
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
    this.prefixIconConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    this.onMenuWillOpen,
  });

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

  final BoxConstraints? prefixIconConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<SelectionPopupModel>? validator;

  final Function(SelectionPopupModel)? onChanged;

  final VoidCallback? onMenuWillOpen;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: dropDownWidget,
          )
        : dropDownWidget;
  }

  Widget get dropDownWidget => DropdownButtonFormField2<SelectionPopupModel>(
        onMenuStateChange: (isOpen) {
          if (isOpen) {
            onMenuWillOpen?.call();
          }
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 400.v,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.h),
            color: theme.colorScheme.onPrimary,
          ),
          offset: const Offset(0, -5),
          elevation: 8,
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        isExpanded: true,
        value: null,
        focusNode: focusNode,
        buttonStyleData: ButtonStyleData(
          height: iconSize ?? 24.h,
        ),
        iconStyleData: IconStyleData(
          icon: icon ?? Icon(Icons.arrow_drop_down, size: iconSize ?? 24),
          iconSize: iconSize ?? 24,
        ),
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
      );

  InputDecoration get decoration => InputDecoration(
        prefixIcon: prefix,
        prefixIconConstraints: prefixIconConstraints,
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
