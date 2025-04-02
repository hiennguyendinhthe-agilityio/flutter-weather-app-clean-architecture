// A class that offers pre-defined button styles for customizing button appearance
import 'package:flutter/material.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/size_utils.dart';

class CustomButtonStyles {
  // Outline button style
  static ButtonStyle get outlinePrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              18.h,
            ),
            bottomLeft: Radius.circular(
              18.h,
            ),
          ),
        ),
        shadowColor: theme.colorScheme.primary.withValues(
          alpha: 0.5,
        ),
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get outlinePrimaryBL16 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              16.h,
            ),
            bottomLeft: Radius.circular(
              16.h,
            ),
          ),
        ),
        shadowColor: theme.colorScheme.primary.withValues(
          alpha: 0.55,
        ),
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get outlinePrimaryBL18 => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              18.h,
            ),
            bottomLeft: Radius.circular(
              18.h,
            ),
          ),
        ),
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get outlinePrimaryTL12 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        shadowColor: theme.colorScheme.primary.withValues(
          alpha: 0.5,
        ),
        padding: EdgeInsets.zero,
      );

  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        elevation: WidgetStateProperty.all<double>(0),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        side: WidgetStateProperty.all<BorderSide>(
          BorderSide(color: Colors.transparent),
        ),
      );
}
