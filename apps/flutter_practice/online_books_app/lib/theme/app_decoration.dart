import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/theme/theme_helper.dart';

class AppDecoration {
  // Fill decoration
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgRectangle159),
          fit: BoxFit.fill,
        ),
      );

  static BoxDecoration get fillOnPrimaryOne => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );

  static BoxDecoration get fillOnPrimaryTwo => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        image: DecorationImage(
          image: AssetImage(ImageConstant.imageLogin),
          fit: BoxFit.fill,
        ),
      );

  static BoxDecoration get primaryappBlackSqueez => BoxDecoration(
      color: appTheme.gray50,
      border: Border.all(
          color: theme.colorScheme.onPrimaryContainer, width: 0.5.h));

  static BoxDecoration get primaryappBlackSqueeze => BoxDecoration(
        color: appTheme.gray50,
        image: DecorationImage(
          image: AssetImage(ImageConstant.imageOnboarding3),
          fit: BoxFit.fill,
        ),
      );
  static BoxDecoration get primaryappGrandis => BoxDecoration(
        color: appTheme.yellow700,
      ); // Fill decorations
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.imgRectangle159,
          ),
          fit: BoxFit.fill,
        ),
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: appTheme.whiteA700,
      );
  static BoxDecoration get fillWhiteA7001 => BoxDecoration(
        color: appTheme.whiteA700,
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.imgB71a5c18e0287ef5dde6cbc0c6384a19,
          ),
          fit: BoxFit.fill,
        ),
      );

// Gradient decorations
  static BoxDecoration get gradientGrayToGray => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.gray50000,
            appTheme.blueGray40000,
            appTheme.gray600
          ],
        ),
      );
  static BoxDecoration get gradientPrimaryContainerToGrayB => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.48, 0.51),
          end: Alignment(0.48, 0),
          colors: [theme.colorScheme.primaryContainer, appTheme.gray800B2],
        ),
      );
  static BoxDecoration get gradientOnPrimaryToGrayB => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.48, 0.63),
          end: Alignment(0.48, 0),
          colors: [theme.colorScheme.onPrimary, appTheme.gray800B2],
        ),
      );
  // Outline decorations
  static BoxDecoration get outlineOnPrimaryContainer => BoxDecoration(
        color: appTheme.gray50,
      );
  static BoxDecoration get outlinePrimary => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      );

  static BoxDecoration get stack5 => BoxDecoration(
        image: DecorationImage(
            image: fs.Svg(
              ImageConstant.imgUnion,
            ),
            fit: BoxFit.fill),
      );

  static BoxDecoration get outlineGray => BoxDecoration(
        color: appTheme.gray50,
        border: Border.all(
          color: appTheme.gray500,
          width: 0.25.h,
        ),
      );

  static BoxDecoration get column12 => BoxDecoration();
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder80 => BorderRadius.circular(
        80.h,
      );

  // Custom borders
  static BorderRadius get customBorderBL12 => BorderRadius.vertical(
        bottom: Radius.circular(12.h),
      );
  static BorderRadius get customBorderBL16 => BorderRadius.only(
        topRight: Radius.circular(16.h),
        bottomLeft: Radius.circular(16.h),
      );
  static BorderRadius get customBorderTL12 => BorderRadius.vertical(
        top: Radius.circular(12.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
        12.h,
      );
  static BorderRadius get roundedBorder16 => BorderRadius.circular(
        16.h,
      );
}
