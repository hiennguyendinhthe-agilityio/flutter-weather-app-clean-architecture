import 'package:bazar_books_design/core/utils/size_type.dart';

class FontSizes {
  FontSizes._();

  // Mobile Font Sizes
  static const double mobileXXl = 28.0;
  static const double mobileXl = 24.0;
  static const double mobileL = 20.0;
  static const double mobileM = 16.0;
  static const double mobileS = 14.0;
  static const double mobileXs = 12.0;

  // Tablet Font Sizes
  static const double tabletXXl = 32.0;
  static const double tabletXl = 28.0;
  static const double tabletL = 24.0;
  static const double tabletM = 20.0;
  static const double tabletS = 16.0;
  static const double tabletXs = 14.0;

  // Desktop Font Sizes
  static const double desktopXXl = 36.0;
  static const double desktopXl = 30.0;
  static const double desktopL = 26.0;
  static const double desktopM = 22.0;
  static const double desktopS = 18.0;
  static const double desktopXs = 16.0;

  static double getFontSizes(SizeType sizeType, String deviceType) =>
      switch (deviceType) {
        'mobile' => _getMobileFontSizes(sizeType),
        'tablet' => _getTabletFontSizes(sizeType),
        'desktop' => _getDesktopFontSizes(sizeType),
        _ => 0.0,
      };

  static double _getMobileFontSizes(SizeType sizeType) => switch (sizeType) {
        SizeType.xxl => mobileXXl,
        SizeType.xl => mobileXl,
        SizeType.l => mobileL,
        SizeType.m => mobileM,
        SizeType.s => mobileS,
        SizeType.xs => mobileXs,
      };
  static double _getTabletFontSizes(SizeType sizeType) => switch (sizeType) {
        SizeType.xxl => tabletXXl,
        SizeType.xl => tabletXl,
        SizeType.l => tabletL,
        SizeType.m => tabletM,
        SizeType.s => tabletS,
        SizeType.xs => tabletXs,
      };

  static double _getDesktopFontSizes(SizeType sizeType) => switch (sizeType) {
        SizeType.xxl => desktopXXl,
        SizeType.xl => desktopXl,
        SizeType.l => desktopL,
        SizeType.m => desktopM,
        SizeType.s => desktopS,
        SizeType.xs => desktopXs,
      };
}
