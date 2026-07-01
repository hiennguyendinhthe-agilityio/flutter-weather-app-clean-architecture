import 'package:flutter/material.dart';
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

/// Ergonomic accessors for the Fitness app's theme layers.
///
/// Usage in widgets:
///   final cs  = context.cs;      // ColorScheme — colors, surfaces, text roles
///   final ext = context.fitnessExt; // Gradients + accent series (not in M3)
///   final tt  = context.tt;      // TextTheme — typography scale
extension FitnessThemeContext on BuildContext {
  /// Material 3 [ColorScheme]. Prefer this for all color decisions.
  ColorScheme get cs => Theme.of(this).colorScheme;

  /// App [TextTheme] built from [FitnessTypographyTokens].
  TextTheme get tt => Theme.of(this).textTheme;

  /// The slim [FitnessSemanticExtension] — only gradients & chart accent colors.
  /// Only access this when you need data not expressible by [ColorScheme].
  FitnessSemanticExtension get fitnessExt =>
      Theme.of(this).extension<FitnessSemanticExtension>()!;

  HeartRateChartTheme get heartRateChartTheme =>
      Theme.of(this).extension<HeartRateChartTheme>()!;
  ExpenseDonutChartTheme get expenseDonutChartTheme =>
      Theme.of(this).extension<ExpenseDonutChartTheme>()!;
  NestedRingsChartTheme get nestedRingsChartTheme =>
      Theme.of(this).extension<NestedRingsChartTheme>()!;
  StepsGaugeChartTheme get stepsGaugeChartTheme =>
      Theme.of(this).extension<StepsGaugeChartTheme>()!;
  SalesTimeFilterTheme get salesTimeFilterTheme =>
      Theme.of(this).extension<SalesTimeFilterTheme>()!;
  SalesDonutChartTheme get salesDonutChartTheme =>
      Theme.of(this).extension<SalesDonutChartTheme>()!;
  ExpenseCategoryListTheme get expenseCategoryListTheme =>
      Theme.of(this).extension<ExpenseCategoryListTheme>()!;
  UserProfileHeaderTheme get userProfileHeaderTheme =>
      Theme.of(this).extension<UserProfileHeaderTheme>()!;
  WeeklyCalendarTheme get weeklyCalendarTheme =>
      Theme.of(this).extension<WeeklyCalendarTheme>()!;
  ProjectHorizontalBarTheme get projectHorizontalBarTheme =>
      Theme.of(this).extension<ProjectHorizontalBarTheme>()!;
  SegmentedDonutChartTheme get segmentedDonutChartTheme =>
      Theme.of(this).extension<SegmentedDonutChartTheme>()!;
  FitnessActivityRingsTheme get fitnessActivityRingsTheme =>
      Theme.of(this).extension<FitnessActivityRingsTheme>()!;
  SlidingToggleTheme get slidingToggleTheme =>
      Theme.of(this).extension<SlidingToggleTheme>()!;
  ActivityLevelsListTheme get activityLevelsListTheme =>
      Theme.of(this).extension<ActivityLevelsListTheme>()!;
  RingLegendItemTheme get ringLegendItemTheme =>
      Theme.of(this).extension<RingLegendItemTheme>()!;
}
