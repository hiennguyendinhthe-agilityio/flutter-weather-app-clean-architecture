import 'package:flutter/material.dart';

class FitnessColors {
  // Backgrounds
  static const Color background = Color(0xFF14141E);
  static const Color cardBackground = Color(0xFF1C1C26);
  static const Color cardBorder = Color(0xFF282835);

  // Rings & Charts (solid - existing)
  static const Color activity = Color(0xFFFFE03E); // Yellow
  static const Color health = Color(0xFF3AFF6E); // Green
  static const Color sleep = Color(0xFF4A7BD9); // Muted Blue
  static const Color projectPurple = Color(0xFF9675DB); // Muted Purple
  static const Color projectLime = Color(0xFFAECC35); // Muted Lime

  // Track colors (background rings)
  static Color get activityTrack => activity;
  static Color get healthTrack => health;
  static Color get sleepTrack => sleep;
  static Color get purpleTrack => projectPurple.withValues(alpha: 0.15);
  static Color get limeTrack => projectLime.withValues(alpha: 0.15);

  // Gradient definitions for Health Stats rings
  static const List<Color> activityGradient = [
    Color(0xFF3AFF6E), // Green start
    Color(0xFFCBFF3E), // Lime mid
    Color(0xFFFFE03E), // Yellow end
  ];

  static const List<Color> sleepGradient = [
    Color(0xFF1DE5C2), // Cyan start
    Color(0xFF5A94FF), // Blue mid
    Color(0xFF8B6AFF), // Purple end
  ];

  static const List<Color> healthGradient = [
    Color(0xFF5A94FF), // Blue start
    Color(0xFF1DE5C2), // Cyan mid
    Color(0xFF6BFF8E), // Green end
  ];

  // Activity Level card
  static const Color activityCardBg = Color(0xFF1E1E30);
  static const Color activityCardBorder = Color(0xFF2A2A40);

  // Texts
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8B8B9B);
  static const Color textMuted = Color(0xFF5D5D6E);

  // =============================================
  // Expenses Screen - New Colors
  // =============================================
  static const Color expenseCyan = Color(0xFF1DE5C2);
  static const Color expenseYellow = Color(0xFFD6FF38);
  static const Color expensePink = Color(0xFFFF5CFF);
  static const Color expenseBlue = Color(0xFF5A94FF);
  static const Color expenseBadgeBg = Color(
    0xFFDBFF4B,
  ); // Glowing yellow for the card icon badge
  static const Color expenseBadgeIcon = Color(0xFF14141E);
  // =============================================
  // Sales KPIs Screen - New Colors
  // =============================================
  static const Color salesBackground = Color(0xFF0F111A);
  static const Color salesCardBackground = Color(0xFF1B1D29);
  static const Color salesBlueNeon = Color(0xFF5A94FF); // Bright vibrant blue
  static const Color salesTrack = Color(0xFF1B1D29); // Dark grey track
}
