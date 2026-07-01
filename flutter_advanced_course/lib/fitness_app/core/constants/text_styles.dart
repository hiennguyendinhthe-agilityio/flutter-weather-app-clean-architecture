import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/constants/colors.dart';

class FitnessTextStyles {
  // App Bar Title
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
  );

  // Main Activity Ring Text
  static const TextStyle ringPercentage = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
    letterSpacing: -1.0,
  );

  static const TextStyle ringSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  // Bottom Cards Values (e.g. 6 500, 82 BPM)
  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle chartValue = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle chartValueSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  // Custom Weekly Calendar
  static const TextStyle calendarDay = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle calendarDate = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle calendarDateActive = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  // General legend inside chart
  static const TextStyle legendText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // =============================================
  // Health Stats Screen - New Styles
  // =============================================

  // User Profile Header
  static const TextStyle profileMonth = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle profileSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: FitnessColors.textSecondary,
  );

  // Total Index
  static const TextStyle totalIndexValue = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w800,
    color: FitnessColors.textPrimary,
    letterSpacing: -1.5,
    height: 1.0,
  );

  static const TextStyle totalIndexLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  // Section Header (e.g. "Activity levels")
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
  );

  // Activity Level items
  static const TextStyle activityName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle activityPercent = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textSecondary,
  );

  // Ring endpoint percentage label
  static const TextStyle ringEndpointPercent = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textSecondary,
  );

  // =============================================
  // Projects Screen - New Styles
  // =============================================

  static const TextStyle projectHeader = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle projectDisplayHours = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle projectTimeRange = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: FitnessColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle filterTabActive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle filterTabInactive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: FitnessColors.textMuted,
  );

  static const TextStyle projectNameBold = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle projectHoursText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: FitnessColors.textPrimary,
  );

  // =============================================
  // Expenses Screen - New Styles
  // =============================================

  static const TextStyle expenseMonth = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle expenseTotal = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle expenseTotalGreen = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: FitnessColors.health, // Green up arrow and text
  );

  static const TextStyle expenseCenterValue = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle expenseCenterSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle expenseCategoryName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle expenseCategoryAmount = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
  );

  // =============================================
  // Sales KPIs Screen - New Styles
  // =============================================

  static const TextStyle salesHeaderTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle salesHeaderSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle salesCenterPercentage = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
    letterSpacing: -1.0,
  );

  static const TextStyle salesCenterValue = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle salesCardTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle salesCardAmount = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle salesCardPercentage = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle salesFilterText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle salesFilterTextActive = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
  );

  // =============================================
  // Activity Detail Screen - New Styles
  // =============================================

  // Custom Title
  static const TextStyle activityDetailTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
    letterSpacing: -0.5,
  );

  // Ring Values
  static const TextStyle activityDetailRingValue = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle activityDetailRingSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  // Activity Log Stats
  static const TextStyle logItemValue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle logItemLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );

  // Stats Cards
  static const TextStyle statsCardValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
  );

  static const TextStyle statsCardLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: FitnessColors.textSecondary,
  );

  static const TextStyle activityDetailValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: FitnessColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle activityDetailLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: FitnessColors.textSecondary,
  );
}
