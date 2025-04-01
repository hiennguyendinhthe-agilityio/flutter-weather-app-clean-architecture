import 'dart:math';

import 'package:flutter/material.dart';

import 'size_config.dart';

// Extension on double to provide responsive size utilities
extension SizeExtension on double {
  // Adjust the width based on screen size
  double get w => SizeConfig.scaleWidth(this);

  // Adjust the height based on screen size
  double get h => SizeConfig.scaleHeight(this);

  // Adjust the font size based on screen size
  double get sp => SizeConfig.scaleText(this);

  // Returns the smaller value between the original size and the scaled font size
  double get spMin => min(this, sp);

  // Returns the larger value between the original size and the scaled font size
  double get spMax => max(this, sp);

  // Padding adjustment based on screen width
  double get p => SizeConfig.scaleWidth(this);

  // Margin adjustment based on screen width
  double get m => SizeConfig.scaleWidth(this);

  // Adjust the radius (for borders) based on screen width
  double get r => SizeConfig.scaleWidth(this);

  // Percentage-based width of the screen (e.g., 50.wp for 50% of the screen width)
  double get wp => (SizeConfig.screenWidth * (this / 100));

  // Percentage-based height of the screen (e.g., 50.hp for 50% of the screen height)
  double get hp => (SizeConfig.screenHeight * (this / 100));

  // Diagonal length of the screen (Pythagorean theorem applied to width and height)
  double get diagonal => sqrt(SizeConfig.screenWidth * SizeConfig.screenWidth +
      SizeConfig.screenHeight * SizeConfig.screenHeight);

  // Percentage-based diagonal length of the screen
  double get dp => (diagonal * (this / 100));

  // Screen aspect ratio (width divided by height)
  double get aspectRatio => SizeConfig.screenWidth / SizeConfig.screenHeight;

  // Adds vertical space (height) between widgets
  SizedBox get verticalSpace => SizedBox(height: SizeConfig.scaleHeight(this));

  // Adds horizontal space (width) between widgets
  SizedBox get horizontalSpace => SizedBox(width: SizeConfig.scaleWidth(this));

  // Adjust the icon size based on screen width
  double get iconSize => SizeConfig.scaleWidth(this);

  // Full width of the screen (1.0 fw represents the entire width)
  double get fw => SizeConfig.screenWidth * (this / 1);

  // Full height of the screen (1.0 fh represents the entire height)
  double get fh => SizeConfig.screenHeight * (this / 1);

  // Padding applied to all edges based on screen width
  EdgeInsets get paddingAll => EdgeInsets.all(SizeConfig.scaleWidth(this));

  // Symmetric padding applied horizontally based on screen width
  EdgeInsets get paddingSymmetricH =>
      EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(this));

  // Symmetric padding applied vertically based on screen height
  EdgeInsets get paddingSymmetricV =>
      EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(this));

  // Adjust the border width based on screen width
  double get borderWidth => SizeConfig.scaleWidth(this);
}
