import 'package:bazar_books_design/core/utils/size_type.dart';

class Spacings {
  Spacings._();

  // Mobile Spacings
  static const double mobileXXl = 22.0;
  static const double mobileXl = 18.0;
  static const double mobileL = 14.0;
  static const double mobileM = 10.0;
  static const double mobileS = 8.0;
  static const double mobileXs = 6.0;

  // Tablet Spacings
  static const double tabletXXl = 26.0;
  static const double tabletXl = 20.0;
  static const double tabletL = 16.0;
  static const double tabletM = 12.0;
  static const double tabletS = 10.0;
  static const double tabletXs = 8.0;

  // Desktop Spacings
  static const double desktopXXl = 28.0;
  static const double desktopXl = 22.0;
  static const double desktopL = 18.0;
  static const double desktopM = 14.0;
  static const double desktopS = 12.0;
  static const double desktopXs = 10.0;

  static double getSpacing(SizeType sizeType, String deviceType) =>
      switch (deviceType) {
        'mobile' => _getMobileSpacing(sizeType),
        'tablet' => _getTabletSpacing(sizeType),
        'desktop' => _getDesktopSpacing(sizeType),
        _ => 0.0,
      };

  static double _getMobileSpacing(SizeType sizeType) => switch (sizeType) {
        SizeType.xxl => mobileXXl,
        SizeType.xl => mobileXl,
        SizeType.l => mobileL,
        SizeType.m => mobileM,
        SizeType.s => mobileS,
        SizeType.xs => mobileXs,
      };

  static double _getTabletSpacing(SizeType sizeType) => switch (sizeType) {
        SizeType.xxl => tabletXXl,
        SizeType.xl => tabletXl,
        SizeType.l => tabletL,
        SizeType.m => tabletM,
        SizeType.s => tabletS,
        SizeType.xs => tabletXs,
      };

  static double _getDesktopSpacing(SizeType sizeType) => switch (sizeType) {
        SizeType.xxl => desktopXXl,
        SizeType.xl => desktopXl,
        SizeType.l => desktopL,
        SizeType.m => desktopM,
        SizeType.s => desktopS,
        SizeType.xs => desktopXs,
      };
}
