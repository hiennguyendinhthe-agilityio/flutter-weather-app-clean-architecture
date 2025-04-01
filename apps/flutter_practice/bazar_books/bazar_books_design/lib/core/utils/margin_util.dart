import 'package:bazar_books_design/core/utils/size_type.dart';

class Margins {
  Margins._();

  // Mobile Margins
  static const double mobileLarge = 16.0;
  static const double mobileMedium = 12.0;
  static const double mobileSmall = 8.0;

  // Tablet Margins
  static const double tabletLarge = 20.0;
  static const double tabletMedium = 16.0;
  static const double tabletSmall = 12.0;

  // Desktop Margins
  static const double desktopLarge = 24.0;
  static const double desktopMedium = 18.0;
  static const double desktopSmall = 14.0;

  static double getMargin(SizeType sizeType, String deviceType) =>
      switch (deviceType) {
        'mobile' => _getMobileMargin(sizeType),
        'tablet' => _getTabletMargin(sizeType),
        'desktop' => _getDesktopMargin(sizeType),
        _ => 0.0,
      };

  // Mobile Margin
  static double _getMobileMargin(SizeType sizeType) => switch (sizeType) {
        SizeType.l => mobileLarge,
        SizeType.m => mobileMedium,
        SizeType.s => mobileSmall,
        _ => 0.0
      };

  // Tablet Margin
  static double _getTabletMargin(SizeType sizeType) => switch (sizeType) {
        SizeType.l => tabletLarge,
        SizeType.m => tabletMedium,
        SizeType.s => tabletSmall,
        _ => 0.0
      };

  // Desktop Margin
  static double _getDesktopMargin(SizeType sizeType) => switch (sizeType) {
        SizeType.l => desktopLarge,
        SizeType.m => desktopMedium,
        SizeType.s => desktopSmall,
        _ => 0.0
      };
}
