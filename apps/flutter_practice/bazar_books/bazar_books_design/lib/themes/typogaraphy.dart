library;

import 'package:bazar_books_design/core/resources/assets_generated/fonts.gen.dart';
import 'package:flutter/material.dart';

/// Calculate height by dividing line height by font size
/// Example [heightHeadingBoldH1] = [lineHeightHeadingBoldH1] / [fontSizeHeadingBoldH1]

class BazUiTypography {
  BazUiTypography._();

  // Fonts HelveticaNeue
  static const String familOpenSans = FontFamily.openSans;

  // Fonts MonaSans
  static const String familyRoboto = FontFamily.roboto;

  // Sizes Heading
  // - HeadingBoldH1
  static const double fontSizeHeadingBoldH1 = 40;
  static const double lineHeightHeadingBoldH1 = 54;
  static const double heightHeadingBoldH1 = 1.4;

  // - HeadingBoldH2
  static const double fontSizeHeadingBoldH2 = 32;
  static const double lineHeightHeadingBoldH2 = 32;
  static const double heightHeadingBoldH2 = 1.3;

  // - HeadingBoldH3
  static const double fontSizeHeadingBoldH3 = 24;
  static const double lineHeightHeadingBoldH3 = 32;
  static const double heightHeadingBoldH3 = 1.4;

  // - HeadingBoldH4
  static const double fontSizeHeadingBoldH4 = 20;
  static const double lineHeightHeadingBoldH4 = 28;
  static const double heightHeadingBoldH4 = 1.4;

  // - HeadingBoldH5
  static const double fontSizeHeadingBoldH5 = 18;
  static const double lineHeightHeadingBoldH5 = 24;
  static const double heightHeadingBoldH5 = 1.5;

  // - HeadingBoldH6
  static const double fontSizeHeadingBoldH6 = 16;
  static const double lineHeightHeadingBoldH6 = 24;
  static const double heightHeadingBoldH6 = 1.5;

  // - BodyXlargeMedium
  static const double fontSizeBodyXlargeMedium = 18;
  static const double lineHeightBodyXlargeMedium = 27;
  static const double heightBodyXlargeMedium = 1.5;

  // - BodyLargeMedium
  static const double fontSizeBodyLargeMedium = 16;
  static const double lineHeightBodyLargeMedium = 24;
  static const double heightBodyLargeMedium = 1.5;

  // - BodyLargeRegular
  static const double fontSizeBodyLargeRegular = 16;
  static const double lineHeightBodyLargeRegular = 24;
  static const double heightBodyLargeRegular = 1.5;

  // - BodyMediumBold
  static const double fontSizeBodyMediumBold = 14;
  static const double lineHeightBodyMediumBold = 20;
  static const double heightBodyMediumBold = 1.5;

  // - BodyMedium
  static const double fontSizeBodyMedium = 14;
  static const double lineHeightBodyMedium = 20;
  static const double heightBodyMedium = 1.5;

  // - BodyMediumRegular
  static const double fontSizeBodyMediumRegular = 14;
  static const double lineHeightBodyMediumRegular = 20;
  static const double heightBodyMediumRegular = 1.5;

  // - BodySmallBold
  static const double fontSizeBodySmallBold = 12;
  static const double lineHeightBodySmallBold = 16;
  static const double heightBodySmallBold = 1.3;

  // - BodySmallMedium
  static const double fontSizeBodySmallMedium = 12;
  static const double lineHeightBodySmallMedium = 16;
  static const double heightBodySmallMedium = 1.3;

  // - BodySmallRegular
  static const double fontSizeBodySmallRegular = 12;
  static const double lineHeightBodySmallRegular = 20;
  static const double heightBodySmallRegular = 1.3;
}

class BazUiTypographyFoundation {
  BazUiTypographyFoundation._();

  //
  static const TextStyle buttonStyle = TextStyle();

  // Text

  static final h1TextStyle = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familOpenSans,
    fontSize: BazUiTypography.fontSizeHeadingBoldH1,
    height: BazUiTypography.heightHeadingBoldH1,
  );
  static final h2TextStyle = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familOpenSans,
    fontSize: BazUiTypography.fontSizeHeadingBoldH2,
    height: BazUiTypography.heightHeadingBoldH2,
  );
  static final h3TextStyle = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familOpenSans,
    fontSize: BazUiTypography.fontSizeHeadingBoldH3,
    height: BazUiTypography.heightHeadingBoldH3,
  );
  static final h4TextStyle = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familOpenSans,
    fontSize: BazUiTypography.fontSizeHeadingBoldH4,
    height: BazUiTypography.heightHeadingBoldH4,
  );
  static final h5TextStyle = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familOpenSans,
    fontSize: BazUiTypography.fontSizeHeadingBoldH5,
    height: BazUiTypography.heightHeadingBoldH5,
  );
  static final h6TextStyle = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familOpenSans,
    fontSize: BazUiTypography.fontSizeHeadingBoldH6,
    height: BazUiTypography.heightHeadingBoldH6,
  );
  static final bodyXlargeMedium = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontSize: BazUiTypography.fontSizeBodyXlargeMedium,
    height: BazUiTypography.heightBodyXlargeMedium,
  );
  static final bodyLargeMedium = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontSize: BazUiTypography.fontSizeBodyLargeMedium,
    height: BazUiTypography.heightBodyLargeMedium,
  );
  static final bodyLargeRegular = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontSize: BazUiTypography.fontSizeBodyLargeRegular,
    height: BazUiTypography.heightBodyLargeRegular,
  );
  static final bodyMediumBold = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontWeight: FontWeight.normal,
    fontSize: BazUiTypography.fontSizeBodyMediumBold,
    height: BazUiTypography.heightBodyMediumBold,
  );
  static final bodyMedium = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontWeight: FontWeight.normal,
    fontSize: BazUiTypography.fontSizeBodyMedium,
    height: BazUiTypography.heightBodyMedium,
  );
  static final bodyMediumRegular = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontWeight: FontWeight.normal,
    fontSize: BazUiTypography.fontSizeBodyMediumRegular,
    height: BazUiTypography.heightBodyMediumRegular,
  );
  static final bodySmallBold = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontWeight: FontWeight.normal,
    fontSize: BazUiTypography.fontSizeBodySmallBold,
    height: BazUiTypography.heightBodySmallBold,
  );
  static final bodySmallMedium = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontWeight: FontWeight.normal,
    fontSize: BazUiTypography.fontSizeBodySmallMedium,
    height: BazUiTypography.heightBodySmallMedium,
  );
  static final bodySmallRegular = _defaultTextStyle.copyWith(
    fontFamily: BazUiTypography.familyRoboto,
    fontWeight: FontWeight.normal,
    fontSize: BazUiTypography.fontSizeBodySmallRegular,
    height: BazUiTypography.heightBodySmallRegular,
  );
}

TextStyle _defaultTextStyle = const TextStyle(
  fontSize: 16,
  fontFamily: BazUiTypography.familOpenSans,
  fontWeight: FontWeight.bold,
  height: 1.5,
);
