import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// ACCOUNT STATISTICS THEME CONSTANTS
// ─────────────────────────────────────────────────────────────

abstract final class AccountStatsTheme {
  // ── Backgrounds
  static const Color scaffoldBg = Color(0xFF121212);
  static const Color cardBg = Color(0xFF1F1F23);

  // ── Chart: Followers bar — solid vibrant purple
  static const Color followersColor = Color(0xFF6C5DD3);

  // ── Chart: Clicks bar — dark semi-transparent slate purple (≈80% opacity).
  //    0xCC = 204/255 ≈ 80 % alpha; the hue matches the dark card background.
  static const Color clicksBarColor = Color(0xCC3D3858);

  // ── Chart decorations
  //    gridLine is multiplied by ~0.08 alpha inside the painter itself,
  //    so this can stay at full opacity here.
  static const Color gridLine = Color(0xFFAEAED6);
  static const Color axisLabel = Color(0xFF6B6B7E);

  // ── Table
  static const Color tableHeaderColor = Color(0xFF6B6B7E);
  static const Color tableTextColor = Color(0xFFE0E0E8);
  static const Color dividerColor = Color(0xFF2A2A35);

  // ── Text
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF9898A8);

  // ── "All" filter button
  static const Color filterBg = Color(0xFF6C5DD3);
  static const Color filterText = Color(0xFFFFFFFF);

  // ── AppBar
  static const Color appBarBg = Color(0xFF1A1A1F);
  static const Color appBarText = Color(0xFFFFFFFF);

  // ── Legend glassmorphic capsule
  static const Color legendCapsuleBorder = Color(0x22FFFFFF); // 13% white
  static const Color legendCapsuleBg = Color(0x18FFFFFF); // 10% white

  // ── Misc
  static const double legendDotSize = 7.0;
  static BorderRadius get cardRadius => BorderRadius.circular(24);
}
