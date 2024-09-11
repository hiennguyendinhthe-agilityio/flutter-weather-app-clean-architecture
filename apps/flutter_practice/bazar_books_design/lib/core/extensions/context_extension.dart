library;

import 'package:bazar_books_design/core/resources/l10n_generated/l10n.dart';
import 'package:flutter/material.dart';

extension ContextHelper on BuildContext {
  ThemeData get themeData => Theme.of(this);

  BazUiS get bazS => BazUiS.current;

  ColorScheme get colorScheme => themeData.colorScheme;

  TextTheme get textTheme => themeData.textTheme;

  InputDecorationTheme get inputDecorationTheme =>
      themeData.inputDecorationTheme;
}
