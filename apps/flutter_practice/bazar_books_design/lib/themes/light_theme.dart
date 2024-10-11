import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:bazar_books_design/themes/colors.dart';
import 'package:bazar_books_design/themes/typogaraphy.dart';
import 'package:flutter/material.dart';

part 'color_scheme.dart';

final bazUiLightTheme = ThemeData.light().copyWith(
  /// ---------- Bottom Navigation Bar Theme ----------
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: _lightColorScheme.onSecondary,
    selectedItemColor: _lightColorScheme.primary,
    unselectedItemColor: _lightColorScheme.tertiary,
    selectedLabelStyle: BazUiTypographyFoundation.bodySmallMedium.copyWith(
      fontWeight: FontWeight.normal,
      color: _lightColorScheme.primary,
    ),
    unselectedLabelStyle: BazUiTypographyFoundation.bodySmallMedium.copyWith(
      fontWeight: FontWeight.normal,
      color: _lightColorScheme.tertiary,
    ),
    selectedIconTheme: IconThemeData(
      color: _lightColorScheme.primary,
    ),
    unselectedIconTheme: IconThemeData(
      color: _lightColorScheme.tertiary,
    ),
  ),
  highlightColor: Colors.transparent,

  splashColor: Colors.transparent,

  /// ---------- Brightness ----------
  brightness: Brightness.light,

  /// ---------- Primary Color ----------
  primaryColor: _lightColorScheme.primary,
  scaffoldBackgroundColor: _lightColorScheme.surface,
  canvasColor: Colors.transparent,

  /// ---------- Other Color ----------
  hintColor: _lightColorScheme.onPrimary,
  disabledColor: _lightColorScheme.secondaryContainer,

  /// ---------- AppBar Theme ----------
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: _lightColorScheme.primary,
    backgroundColor: _lightColorScheme.surface,
  ),

  /// ---------- Icon Theme ----------
  iconTheme: const IconThemeData(),
  primaryIconTheme: const IconThemeData(),

  actionIconTheme: const ActionIconThemeData(),

  /// ---------- Badge Theme ----------
  badgeTheme: const BadgeThemeData(),

  /// ---------- Text Theme ----------
  textTheme: TextTheme(
    displayLarge: BazUiTypographyFoundation.h1TextStyle.copyWith(
      color: _lightColorScheme.onPrimaryContainer,
    ),
    displayMedium: BazUiTypographyFoundation.h5TextStyle.copyWith(
      color: _lightColorScheme.onSecondary,
    ),
    headlineLarge: BazUiTypographyFoundation.h2TextStyle.copyWith(
      color: _lightColorScheme.onPrimaryContainer,
    ),
    headlineMedium: BazUiTypographyFoundation.h3TextStyle.copyWith(
      color: _lightColorScheme.onSecondary,
    ),
    headlineSmall: BazUiTypographyFoundation.h4TextStyle.copyWith(
      color: _lightColorScheme.onSecondaryContainer,
    ),
    titleLarge: TextStyle(
        color: _lightColorScheme.onSecondaryContainer,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans'),
    titleMedium: TextStyle(
        color: _lightColorScheme.onSecondaryContainer,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans'),
    titleSmall: TextStyle(
        color: _lightColorScheme.onSecondaryContainer,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'OpenSans'),
    labelLarge: TextStyle(
      color: _lightColorScheme.onSecondaryContainer,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    labelMedium: TextStyle(
      color: _lightColorScheme.tertiary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    labelSmall: BazUiTypographyFoundation.bodySmallBold.copyWith(
      color: _lightColorScheme.onSecondary,
    ),
    bodyLarge: TextStyle(
      color: _lightColorScheme.onSecondaryContainer,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    bodyMedium: TextStyle(
      color: _lightColorScheme.onSecondaryContainer,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto',
    ),
    bodySmall: TextStyle(
      color: _lightColorScheme.primary,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(200),
    ),
    buttonColor: _lightColorScheme.primary,
    disabledColor: _lightColorScheme.secondaryContainer,
    padding: const EdgeInsets.all(12),
    colorScheme: _lightColorScheme,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shadowColor:
          WidgetStateProperty.resolveWith((states) => Colors.transparent),
      maximumSize: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => Size.infinite,
      ),
      textStyle: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) =>
            BazUiTypographyFoundation.h6TextStyle.copyWith(fontSize: 16.0.sp),
      ),
      iconColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => _lightColorScheme.onPrimary,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => _lightColorScheme.onPrimary,
      ),
      backgroundColor:
          WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return _lightColorScheme.secondaryContainer;
        }

        return _lightColorScheme.primary;
      }),
      padding: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) =>
            const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      ),
    ),
  ),

  /// ---------- Input Decoration Theme ----------
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: _lightColorScheme.tertiary,
      fontSize: 14.0.sp,
    ),
    hintStyle: TextStyle(
      color: _lightColorScheme.tertiary,
    ),
    contentPadding: const EdgeInsets.only(
      top: 10,
      bottom: 12,
      left: 16,
      right: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    isDense: true,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: _lightColorScheme.primary,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: _lightColorScheme.onSecondary,
      ),
    ),
    filled: true,
    fillColor: _lightColorScheme.onSecondary,
  ),
  colorScheme: _lightColorScheme.copyWith(
    surfaceContainerLowest: _lightColorScheme.surfaceContainerLowest,
  ),
);

final bazUiDarkTheme = ThemeData.dark().copyWith();
