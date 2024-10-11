import 'package:bazar_books_design/core/utils/size_type.dart';

class ButtonSizes {
  ButtonSizes._();

  // Mobile Button Sizes
  static const double mobileLarge = 60.0;
  static const double mobileMedium = 50.0;
  static const double mobileSmall = 40.0;

  // Tablet Button Sizes
  static const double tabletLarge = 70.0;
  static const double tabletMedium = 60.0;
  static const double tabletSmall = 50.0;

  // Desktop Button Sizes
  static const double desktopLarge = 80.0;
  static const double desktopMedium = 70.0;
  static const double desktopSmall = 60.0;

  static double getButtonSizes(SizeType sizeType, String deviceType) =>
      switch (deviceType) {
        'mobile' => _getMobileButtonSizes(sizeType),
        'tablet' => _getTabletButtonSizes(sizeType),
        'desktop' => _getDesktopButtonSizes(sizeType),
        _ => 0.0,
      };

  static double _getMobileButtonSizes(SizeType sizeType) => switch (sizeType) {
        SizeType.l => mobileLarge,
        SizeType.m => mobileMedium,
        SizeType.s => mobileSmall,
        _ => 0.0
      };

  // Tablet ButtonSizes
  static double _getTabletButtonSizes(SizeType sizeType) => switch (sizeType) {
        SizeType.l => tabletLarge,
        SizeType.m => tabletMedium,
        SizeType.s => tabletSmall,
        _ => 0.0
      };
  // Desktop ButtonSizes
  static double _getDesktopButtonSizes(SizeType sizeType) => switch (sizeType) {
        SizeType.l => desktopLarge,
        SizeType.m => desktopMedium,
        SizeType.s => desktopSmall,
        _ => 0.0
      };
}
