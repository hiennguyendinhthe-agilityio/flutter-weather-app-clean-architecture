import 'package:flutter/material.dart';

import 'component_themes/fitness_appbar_style.dart';
import 'component_themes/fitness_button_styles.dart';
import 'component_themes/fitness_card_style.dart';
import 'extensions/fitness_semantic_extension.dart';
import 'semantic/fitness_color_scheme.dart';
import 'tokens/color_tokens.dart';
import 'tokens/typography_tokens.dart';

/// Layer 4: ThemeData Assembly.
///
/// This class is a PURE assembler. Its only job is to wire together
/// the outputs of all lower layers:
///   Layer 1 (Tokens) → Layer 2 (Semantic) → Layer 3 (Component) → ThemeData
///
/// Rules enforced here:
///   - NO raw [Color] literals. All colors come from [FitnessColorScheme]
///     (which reads [FitnessColorTokens]).
///   - NO raw font sizes. All typography comes from [FitnessTypographyTokens].
///   - NO business logic. This is configuration, not behavior.
abstract final class AppTheme {
  AppTheme._();

  static ThemeData dark() => _build(
    colorScheme: FitnessColorScheme.dark(),
    extension: const FitnessSemanticExtension.dark(),
    scaffoldBg: FitnessColorTokens.neutral900,
  );

  static ThemeData light() => _build(
    colorScheme: FitnessColorScheme.light(),
    extension: const FitnessSemanticExtension.light(),
    scaffoldBg: FitnessColorTokens.neutralL50,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Private assembly
  // ─────────────────────────────────────────────────────────────────────────

  static ThemeData _build({
    required ColorScheme colorScheme,
    required FitnessSemanticExtension extension,
    required Color scaffoldBg,
  }) {
    final textTheme = FitnessTypographyTokens.buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBg,

      // ── Semantic Extension (gradients only) ──
      extensions: [extension],

      // ── Component Themes (Layer 3 factories) ──
      appBarTheme: FitnessAppBarStyle.appBarTheme(colorScheme, textTheme),
      cardTheme: FitnessCardStyle.cardTheme(colorScheme),
      elevatedButtonTheme: FitnessButtonStyles.elevatedButtonTheme(colorScheme),
      filledButtonTheme: FitnessButtonStyles.filledButtonTheme(colorScheme),
      textButtonTheme: FitnessButtonStyles.textButtonTheme(colorScheme),

      // ── Navigation Bar ──
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onPrimaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = textTheme.labelMedium;
          if (states.contains(WidgetState.selected)) {
            return base?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            );
          }
          return base?.copyWith(color: colorScheme.onSurfaceVariant);
        }),
      ),

      // ── Bottom Navigation Bar ──
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: textTheme.labelMedium,
      ),

      // ── Icon ──
      iconTheme: IconThemeData(color: colorScheme.onSurface),

      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
