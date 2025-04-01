import 'package:flutter/material.dart';
import 'package:online_books_app/theme/theme_helper.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.onChanged,
    this.alignment,
    this.value,
    this.width,
    this.height,
    this.margin,
  });

  final Alignment? alignment;

  final bool? value;

  final Function(bool) onChanged;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: alignment != null
          ? Align(
              alignment: alignment ?? Alignment.center,
              child: switchWidget,
            )
          : switchWidget,
    );
  }

  Widget get switchWidget => Switch(
        trackOutlineColor: WidgetStateColor.resolveWith((state) {
          if (state.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return Colors.white;
        }),
        activeColor: theme.colorScheme.primary,
        activeTrackColor: Colors.white,
        value: value ?? false,
        onChanged: (value) => onChanged(value),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        focusColor: Colors.white,
        hoverColor: Colors.white,
        splashRadius: 0,
        focusNode: FocusNode(),
        inactiveThumbColor: appTheme.gray400,
      );
}
