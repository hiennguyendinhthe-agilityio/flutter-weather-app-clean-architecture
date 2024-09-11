library;

import 'package:flutter/material.dart';

class BazColorTokens {
  BazColorTokens._();

  static const Color backgroundGrey = Color(0xFFF7F8FA);
  static const Color backgroundBlue = Color(0xFFF8FBFF);
  static const Color backgroundPurple = Color(0xFFFAFAFF);

  static const Color shadow = Color(0xFF080B12);

  static const Color generalPrimaryRegWhite = Color(0xFFFFFFFF);
  static const Color bazBasicDarkgeneralPrimaryRegBlack = Color(0xFF000000);

  static const int generalGrey = 0xFF080B12;

  static const generalGreyscale = MaterialColor(
    generalGrey,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFE8E8E8),
      300: Color(0xFFD6D6D6),
      400: Color(0xFFB8B8B8),
      500: Color(0xFFA6A6A6),
      600: Color(0xFF7A7A7A),
      700: Color(0xFF454545),
      800: Color(0xFF292929),
      900: Color(0xFF121212),
    },
  );

  static const generalPrimary = MaterialColor(
    generalGrey,
    <int, Color>{
      50: Color(0xFFFAF9FD),
      100: Color(0xFFE5DEF8),
      200: Color(0xFFCABCEF),
      300: Color(0xFFA28CE0),
      400: Color(0xFF7D64C3),
      500: Color(0xFF54408C),
      600: Color(0xFF352368),
      700: Color(0xFF251554),
      800: Color(0xFF10052F),
      900: Color(0xFF09031B),
    },
  );

  static const int generalWhite = 0xFFFFFFFF;

  static const generalWhites = MaterialColor(
    generalWhite,
    <int, Color>{
      1: Color(0xFFFFFFFF),
    },
  );

  static const int generalPurple = 0xFF462B9E;

  static const generalPurples = MaterialColor(
    generalPurple,
    <int, Color>{
      1: Color(0xFF36237B),
      2: Color(0xFF462B9E),
      3: Color(0xFFC4B8E9),
      4: Color(0xFFDCD6E4),
      5: Color(0xFFEEE8F6),
    },
  );

  static const int generalBlue = 0xFF3784FB;

  static const generalBlues = MaterialColor(
    generalBlue,
    <int, Color>{
      1: Color(0xFF205298),
      2: Color(0xFF2867BE),
      3: Color(0xFFBED1EB),
      4: Color(0xFFD2E0E8),
      5: Color(0xFFE4F2FB),
    },
  );

  static const int generalYellow = 0xFFCF5BE00;

  static const generalYellows = MaterialColor(
    generalYellow,
    <int, Color>{
      1: Color(0xFF9C6D1B),
      2: Color(0xFFCD8D1E),
      3: Color(0xFFF0D5A7),
      4: Color(0xFFDDC59B),
      5: Color(0xFFFAF4E8),
    },
  );

  static const int generalOrange = 0xFFFF8C39;

  static const int generalRed = 0xFFEF5A56;

  static const generalReds = MaterialColor(
    generalRed,
    <int, Color>{
      1: Color(0xFF901F2E),
      2: Color(0xFFBE2537),
      3: Color(0xFFE4ABB1),
      4: Color(0xFFD29EA4),
      5: Color(0xFFF8E9EB),
    },
  );
}
