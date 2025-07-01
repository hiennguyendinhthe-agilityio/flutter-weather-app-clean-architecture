import 'package:flutter/material.dart';
import 'package:task_management_app/core/themes/app_colors.dart';
import 'package:task_management_app/core/themes/app_palette.dart';
import 'package:task_management_app/core/themes/typography.dart';

class PtTheme {
  static ThemeData get light {
    final defaultTheme = ThemeData.light(
      useMaterial3: true,
    );

    return defaultTheme.copyWith(
        colorScheme: PtColors.light,
        brightness: Brightness.light,
        textTheme: _textTheme,
        inputDecorationTheme: _inputDecorationTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: PtPalette.purple[5],
            foregroundColor: Colors.white,
            textStyle: _textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: PtPalette.purple[5],
            textStyle: _textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          foregroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: PtTypography.familyBahnschrift,
            fontSize: PtTypography.fontSizeLabelLarge,
            fontWeight: FontWeight.w400,
            color: PtPalette.genericBlack,
          ),
        ));
  }

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeDisplayLarge,
      fontWeight: FontWeight.w700,
      color: PtPalette.genericBlack,
    ),
    displayMedium: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeDisplayMedium,
      fontWeight: FontWeight.w700,
      color: PtPalette.genericBlack,
    ),
    displaySmall: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeDisplaySmall,
      fontWeight: FontWeight.w700,
      color: PtPalette.genericBlack,
    ),
    headlineLarge: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeHeadlineLarge,
      fontWeight: FontWeight.w700,
      color: PtPalette.genericBlack,
    ),
    headlineMedium: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeHeadlineMedium,
      fontWeight: FontWeight.w700,
      color: PtPalette.genericBlack,
    ),
    headlineSmall: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeHeadlineSmall,
      fontWeight: FontWeight.w700,
      color: PtPalette.genericBlack,
    ),
    titleLarge: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeTitleLarge,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
    titleMedium: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeTitleMedium,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
    titleSmall: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeTitleSmall,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
    labelLarge: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeLabelLarge,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
    labelMedium: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeLabelMedium,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
    labelSmall: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeLabelSmall,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
    bodyLarge: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeBodyLarge,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
    bodyMedium: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
    bodySmall: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeBodySmall,
      fontWeight: FontWeight.w400,
      color: PtPalette.genericBlack,
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: PtPalette.grey[4],
    prefixIconColor: PtPalette.grey[5],
    suffixIconColor: PtPalette.grey[5],
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    constraints: const BoxConstraints(minHeight: 48),
    suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    hintStyle: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeLabelLarge,
      fontWeight: FontWeight.w400,
      height: 1.14,
      color: PtPalette.grey[5],
    ),
    labelStyle: TextStyle(
      fontFamily: PtTypography.familyBahnschrift,
      fontSize: PtTypography.fontSizeLabelLarge,
      fontWeight: FontWeight.w400,
      color: PtPalette.grey[5],
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: PtPalette.grey[2]!,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    outlineBorder: BorderSide(
      color: PtPalette.grey[2]!,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: PtPalette.grey[2]!,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: PtPalette.grey[5]!,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: PtPalette.red,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: PtPalette.red,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    errorStyle: const TextStyle(
      fontSize: 12,
      height: 1.4,
      color: PtPalette.red,
    ),
  );
}
