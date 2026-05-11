import 'package:flutter/material.dart';

import '../theme/fitness_theme_extension.dart';

extension FitnessThemeContext on BuildContext {
  FitnessThemeExtension get fitnessTheme =>
      Theme.of(this).extension<FitnessThemeExtension>()!;
}
