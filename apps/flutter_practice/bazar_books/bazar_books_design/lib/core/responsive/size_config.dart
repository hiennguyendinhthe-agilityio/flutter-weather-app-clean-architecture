import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double _designWidth;
  static late double _designHeight;

  /// Initializes [SizeConfig] with the given [BuildContext] and design dimensions.
  ///
  /// [designWidth] and [designHeight] are used to calculate the scale factors
  /// for [blockSizeHorizontal] and [blockSizeVertical].
  ///
  static void init(BuildContext context,
      {double designWidth = 375, double designHeight = 812}) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;

    _designWidth = designWidth;
    _designHeight = designHeight;

    blockSizeHorizontal = screenWidth / _designWidth;
    blockSizeVertical = screenHeight / _designHeight;
  }

  static double scaleWidth(double width) {
    return width * blockSizeHorizontal;
  }

  static double scaleHeight(double height) {
    return height * blockSizeVertical;
  }

  static double scaleText(double fontSize) {
    final double scaleFactor = (blockSizeHorizontal + blockSizeVertical) / 2;
    return fontSize * scaleFactor;
  }
}
