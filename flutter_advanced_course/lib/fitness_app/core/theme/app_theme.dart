import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/component_themes/fitness_appbar_style.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/component_themes/fitness_button_styles.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/component_themes/fitness_card_style.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/activity_levels_list_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/expense_category_list_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/expense_donut_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/fitness_activity_rings_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/fitness_semantic_extension.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/heart_rate_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/nested_rings_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/project_horizontal_bar_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/ring_legend_item_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/sales_donut_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/sales_time_filter_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/segmented_donut_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/sliding_toggle_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/steps_gauge_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/user_profile_header_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/weekly_calendar_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/semantic/fitness_color_scheme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/tokens/color_tokens.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/tokens/typography_tokens.dart';

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

      // ── Component Theme Extensions ──
      extensions: [
        extension,
        HeartRateChartTheme(
          backgroundColor: colorScheme.surface,
          barColor: extension.accentPink,
          titleStyle: textTheme.titleSmall,
          valueStyle: textTheme.headlineMedium,
          unitStyle: textTheme.titleMedium,
        ),
        ExpenseDonutChartTheme(
          trackColor: colorScheme.outlineVariant.withValues(alpha: 0.5),
          centerValueStyle: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          centerSubtitleStyle: textTheme.bodyMedium,
          badgeBackgroundColor: colorScheme.primaryContainer,
          badgeIconColor: colorScheme.onPrimaryContainer,
          radialTextColor: colorScheme.onSurfaceVariant,
        ),
        NestedRingsChartTheme(
          percentageStyle: textTheme.titleMedium,
          subtitleStyle: textTheme.bodySmall,
        ),
        StepsGaugeChartTheme(
          trackColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
          progressColor: extension.accentLime,
          titleStyle: textTheme.titleSmall,
          valueStyle: textTheme.headlineMedium,
          goalStyle: textTheme.bodySmall,
        ),
        SalesTimeFilterTheme(
          backgroundColor: colorScheme.surfaceContainerHighest,
          activeBackgroundColor: colorScheme.primaryContainer,
          textStyle: textTheme.bodyMedium,
          activeTextStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        SalesDonutChartTheme(
          trackColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
          progressColor: extension.accentBlue,
          iconBackgroundColor: colorScheme.primaryContainer,
          iconInnerColor: colorScheme.surface,
          iconColor: colorScheme.onPrimaryContainer,
          percentageStyle: textTheme.headlineMedium,
          valueStyle: textTheme.bodySmall,
        ),
        ExpenseCategoryListTheme(
          categoryNameStyle: textTheme.bodyMedium,
          categoryAmountStyle: textTheme.titleMedium,
        ),
        UserProfileHeaderTheme(
          greetingStyle: textTheme.bodyMedium,
          nameStyle: textTheme.titleLarge,
          badgeBackgroundColor: colorScheme.secondaryContainer,
          badgeTextStyle: textTheme.labelSmall,
        ),
        WeeklyCalendarTheme(
          monthTextStyle: textTheme.titleMedium,
          dayTextStyle: textTheme.bodySmall,
          dateTextStyle: textTheme.titleMedium,
          selectedDateTextStyle: textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimary,
          ),
          selectedBackgroundColor: colorScheme.primary,
          todayIndicatorColor: colorScheme.onPrimary,
        ),
        ProjectHorizontalBarTheme(
          titleStyle: textTheme.titleSmall,
          valueStyle: textTheme.bodySmall,
          trackColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        SegmentedDonutChartTheme(
          trackColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
          centerValueStyle: textTheme.headlineMedium,
          centerSubtitleStyle: textTheme.bodySmall,
          dividerColor: colorScheme.surface,
        ),
        FitnessActivityRingsTheme(
          titleStyle: textTheme.headlineMedium,
          subtitleStyle: textTheme.bodySmall,
          trackColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
        SlidingToggleTheme(
          backgroundColor: colorScheme.surfaceContainerHighest,
          thumbColor: colorScheme.surface,
          textStyle: textTheme.bodyMedium,
          selectedTextStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        ActivityLevelsListTheme(
          titleStyle: textTheme.titleMedium,
          durationStyle: textTheme.bodySmall,
          iconBackgroundColor: colorScheme.primaryContainer,
          iconColor: colorScheme.onPrimaryContainer,
        ),
        RingLegendItemTheme(labelStyle: textTheme.bodySmall),
      ],

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
