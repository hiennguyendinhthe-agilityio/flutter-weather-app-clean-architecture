import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/tokens/radius_tokens.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/tokens/spacing_tokens.dart';

/// Layer 3: Component Theme — Button styles.
///
/// WHY [ButtonStyle] instead of a custom ThemeExtension with plain fields?
///
///   The old [FitnessButtonThemeData] stored `backgroundColor` as a plain [Color].
///   This means it cannot express DIFFERENT colors per interactive state:
///   normal, hovered, focused, pressed, disabled.
///
///   Flutter's [ButtonStyle] uses [WidgetStateProperty<T>] (formerly
///   MaterialStateProperty) to resolve values based on the widget's current
///   [WidgetState] set. This is exactly what the Flutter SDK uses for
///   [ElevatedButton], [FilledButton], [OutlinedButton].
///
///   By generating proper [ButtonStyle] objects here, our buttons:
///   - Automatically support hover/ripple on all platforms
///   - Support disabled state via WidgetState.disabled
///   - Are registered into standard [ElevatedButtonThemeData] —
///     no need for a separate ThemeExtension
///
/// Usage (registration in AppTheme):
///   elevatedButtonTheme: FitnessButtonStyles.elevatedButtonTheme(colorScheme),
abstract final class FitnessButtonStyles {
  FitnessButtonStyles._();

  // ── Primary Elevated Button ──
  // Maps to: ElevatedButtonThemeData
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme cs) {
    return ElevatedButtonThemeData(style: _primaryStyle(cs));
  }

  // ── Filled Button (secondary action) ──
  // Maps to: FilledButtonThemeData
  static FilledButtonThemeData filledButtonTheme(ColorScheme cs) {
    return FilledButtonThemeData(style: _secondaryStyle(cs));
  }

  // ── Text Button (ghost / low-emphasis) ──
  static TextButtonThemeData textButtonTheme(ColorScheme cs) {
    return TextButtonThemeData(style: _ghostStyle(cs));
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Private style factories
  // ─────────────────────────────────────────────────────────────────────────

  /// Primary CTA button. Background = colorScheme.primary.
  static ButtonStyle _primaryStyle(ColorScheme cs) {
    return ButtonStyle(
      // WidgetStateProperty resolves color per state set.
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return cs.onSurface.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.pressed)) {
          return cs.primary.withValues(alpha: 0.88);
        }
        if (states.contains(WidgetState.hovered)) {
          return cs.primary.withValues(alpha: 0.92);
        }
        return cs.primary;
      }),

      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return cs.onSurface.withValues(alpha: 0.38);
        }
        return cs.onPrimary;
      }),

      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return cs.onPrimary.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return cs.onPrimary.withValues(alpha: 0.08);
        }
        return null;
      }),

      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return 0.0;
        if (states.contains(WidgetState.pressed)) return 1.0;
        if (states.contains(WidgetState.hovered)) return 3.0;
        return 0.0;
      }),

      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FitnessRadiusTokens.md),
        ),
      ),

      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: FitnessSpacingTokens.xl2,
          vertical: FitnessSpacingTokens.lg,
        ),
      ),

      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  /// Secondary filled button. Background = colorScheme.secondaryContainer.
  static ButtonStyle _secondaryStyle(ColorScheme cs) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return cs.onSurface.withValues(alpha: 0.12);
        }
        return cs.secondaryContainer;
      }),

      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return cs.onSurface.withValues(alpha: 0.38);
        }
        return cs.onSecondaryContainer;
      }),

      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return cs.onSecondaryContainer.withValues(alpha: 0.12);
        }
        return null;
      }),

      elevation: const WidgetStatePropertyAll(0.0),

      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FitnessRadiusTokens.md),
        ),
      ),

      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: FitnessSpacingTokens.xl2,
          vertical: FitnessSpacingTokens.lg,
        ),
      ),

      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Ghost / text button. No background, primary-colored text.
  static ButtonStyle _ghostStyle(ColorScheme cs) {
    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return cs.onSurface.withValues(alpha: 0.38);
        }
        return cs.primary;
      }),

      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return cs.primary.withValues(alpha: 0.12);
        }
        return null;
      }),

      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FitnessRadiusTokens.md),
        ),
      ),

      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
