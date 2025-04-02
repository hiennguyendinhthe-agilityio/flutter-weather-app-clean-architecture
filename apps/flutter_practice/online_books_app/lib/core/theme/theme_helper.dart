import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/pref_utils.dart';
import 'package:online_books_app/core/utils/size_utils.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();

ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
class ThemeHelper {
  // The current app theme
  final _appTheme = PrefUtils().getThemeData();

  /// A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'LightCode': LightCodeColors()
  };

  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorsSchemes.lightCodeColorScheme
  };

  /// Changes the app theme to [newTheme].
  void changeTheme(String newTheme) {
    PrefUtils().setThemeData(newTheme);
    Get.forceAppUpdate();
  }

  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorsSchemes.lightCodeColorScheme;
    return ThemeData(
        visualDensity: VisualDensity.standard,
        colorScheme: colorScheme,
        textTheme: TextThemes.textTheme(colorScheme),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: colorScheme.primary,
                width: 1.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.h),
                  topRight: Radius.circular(16.h),
                  bottomLeft: Radius.circular(16.h),
                  bottomRight: Radius.circular(0.h),
                ),
              ),
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
              padding: EdgeInsets.zero),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.h),
                topRight: Radius.circular(16.h),
                bottomLeft: Radius.circular(16.h),
                bottomRight: Radius.circular(0.h),
              ),
            ),
            shadowColor: colorScheme.primary.withValues(alpha: 0.5),
            elevation: 1,
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            padding: EdgeInsets.zero,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateColor.resolveWith((state) {
            if (state.contains(WidgetState.disabled)) {
              return colorScheme.primary;
            }
            return Colors.transparent;
          }),
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
        ),
        dividerTheme: DividerThemeData(
          thickness: 1,
          space: 1,
          color: appTheme.gray500,
        ));
  }

  /// Returns the LightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorsScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorsScheme.errorContainer,
          fontSize: 16.5.fSize,
          fontFamily: 'Dosis',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.blueGray900,
          fontSize: 14.5.fSize,
          fontFamily: 'Dosis',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.gray50001,
          fontSize: 12.fSize,
          fontFamily: 'Dosis',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 32.5.fSize,
          fontFamily: 'Concert One',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 24.fSize,
          fontFamily: 'Concert One',
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          color: appTheme.blueGray900,
          fontSize: 20.fSize,
          fontFamily: 'Dosis',
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: colorsScheme.primary,
          fontSize: 16.5.fSize,
          fontFamily: 'Dosis',
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: appTheme.gray50,
          fontSize: 14.fSize,
          fontFamily: 'Dosis',
          fontWeight: FontWeight.w700,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorsSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
      primary: Color(0xFFD55D0D),
      secondaryContainer: Color(0xFFA34709),
      onPrimary: Color(0xFFFFFFFF),
      onPrimaryContainer: Color(0xFF2E3731),
      shadow: Color.fromARGB(255, 201, 199, 199));
}

/// Class containing custom colors for a LightCode theme.
class LightCodeColors {
  // Black
  Color get black900 => Color(0xFF000000);

  // Bluegray
  Color get blueGray40000 => Color(0X008E8E8E);
  Color get blueGray900 => Color(0xFF2E3731);
  Color get blueGray90001 => Color(0XFF1F3741);
  Color get blueGray90002 => Color(0XFF292D32);

  // Deeporange
  Color get deepOrange300 => Color(0XFFF49251);

  // Gray
  Color get gray400 => Color(0xFFB3B3B3);
  Color get gray40001 => Color(0xFFC8C8C0);

  Color get gray50 => Color(0xFFF8F8F7);
  Color get gray500 => Color(0xFFA9A08D);
  Color get gray50000 => Color(0x00A5A5A5);
  Color get gray50001 => Color(0xFF98988A);
  Color get gray600 => Color(0xFF7D7D71);
  Color get gray800B2 => Color(0xB24C4C4C);
  // Yellow
  Color get yellow700 => Color(0xFFF9C53D);

  // White
  Color get whiteA700 => Color(0xFFFFFFFF);
}
