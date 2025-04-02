import 'package:flutter/material.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/size_utils.dart';

extension on TextStyle {
  TextStyle get dosis {
    return copyWith(
      fontFamily: 'Dosis',
    );
  }

  TextStyle get concertOne {
    return copyWith(
      fontFamily: 'Concert One',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply
/// various customizations.
class CustomTextStyles {
  static TextStyle get titleLargeConcertOneBlack900Regular_1 =>
      theme.textTheme.titleLarge!.concertOne.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w400,
      );

  // Title text style
  static TextStyle get titleLargeOnPrimaryContainer =>
      theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );

  static TextStyle get titleMediumSecondaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.secondaryContainer,
      ); // Body text style
  static TextStyle get bodyLargeGray50001 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray50001,
      );
  static TextStyle get bodyMediumBlack900 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
      );
  static TextStyle get bodySmallBluegray900 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray900,
      );
  static TextStyle get bodySmallBluegray90001 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 10.fSize,
      );
  static TextStyle get bodySmallErrorContainer =>
      theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static TextStyle get bodySmallGray50 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray50,
        fontSize: 10.fSize,
      );
  static TextStyle get bodySmallGray5010 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray50,
        fontSize: 10.fSize,
      );
  // Dosis text style
  static TextStyle get dosisBluegray900 => TextStyle(
        color: appTheme.blueGray900,
        fontSize: 6.fSize,
        fontWeight: FontWeight.w400,
      ).dosis;
  static TextStyle get dosisGray50 => TextStyle(
        color: appTheme.gray50,
        fontSize: 5.fSize,
        fontWeight: FontWeight.w400,
      ).dosis;
  // Headline text style
  static TextStyle get headlineSmallBlack900 =>
      theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.black900,
      );
  // Title text style
  static TextStyle get titleLargeBluegray900 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.blueGray900,
      );
  static TextStyle get titleLargeDosis =>
      theme.textTheme.titleLarge!.dosis.copyWith(
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleLargeDosisBluegray900 =>
      theme.textTheme.titleLarge!.dosis.copyWith(
        color: appTheme.blueGray900,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleLargeDosisGray50 =>
      theme.textTheme.titleLarge!.dosis.copyWith(
        color: appTheme.gray50,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleLargeGray50 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray50,
      );

  static TextStyle get titleLargeBluegray90001 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.blueGray90001,
      );

  static get titleLarge_1 => theme.textTheme.titleLarge!;

  static TextStyle get titleMediumBlueGray900 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray900,
      );
  static TextStyle get titleMediumErrorContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static TextStyle get titleMediumGray50 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray50,
      );
  static TextStyle get titleMediumGray50Medium =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray50,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleSmallBluegray900 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray900,
        fontWeight: FontWeight.w600,
      );
}
