// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// Layer 1: Design Tokens — Primitive Color Palette.
///
/// Rules:
///   - NO semantic meaning. Names describe the color itself, not its use.
///   - NO Flutter widget dependencies.
///   - Single source of truth for every raw color value in the app.
///   - Consumers of this file are Semantic layers ONLY (never widgets directly).
abstract final class FitnessColorTokens {
  FitnessColorTokens._();

  // ── Neutral (Dark surface scale) ──
  static const Color neutral950 = Color(0xFF0F111A); // deepest bg (sales)
  static const Color neutral900 = Color(0xFF14141E); // dark scaffold
  static const Color neutral850 = Color(0xFF1B1D29); // sales card bg
  static const Color neutral800 = Color(0xFF1C1C26); // dark card bg
  static const Color neutral750 = Color(0xFF1E1E30); // activity card bg dark
  static const Color neutral700 = Color(0xFF282835); // dark border / track
  static const Color neutral650 = Color(
    0xFF2A2A40,
  ); // activity card border dark
  static const Color neutral400 = Color(0xFF5D5D6E); // muted text dark
  static const Color neutral300 = Color(0xFF8B8B9B); // secondary text dark

  // ── Neutral (Light surface scale) ──
  static const Color neutralL50 = Color(0xFFF5F5FA); // light scaffold
  static const Color neutralL100 = Color(0xFFFFFFFF); // light card bg
  static const Color neutralL200 = Color(0xFFE0E0EC); // light border / track
  static const Color neutralL250 = Color(0xFFF0F0FF); // activity card bg light
  static const Color neutralL300 = Color(
    0xFFD8D8F0,
  ); // activity card border light
  static const Color neutralL700 = Color(0xFF6B6B7B); // secondary text light
  static const Color neutralL800 = Color(0xFFAAAAAA); // muted text light
  static const Color neutralL900 = Color(0xFF14141E); // primary text light

  // ── Brand / Accent ──
  // Yellow family
  static const Color yellow300 = Color(0xFFFFE03E); // activity dark
  static const Color yellow400 = Color(0xFFD6FF38); // accent lime
  static const Color yellow500 = Color(0xFFCBFF3E); // gradient mid
  static const Color yellow600 = Color(0xFFC9A500); // activity light
  static const Color yellow700 = Color(0xFF8FB800); // accent lime light

  // Green family
  static const Color green300 = Color(0xFF6BFF8E); // gradient end
  static const Color green400 = Color(0xFF3AFF6E); // health dark
  static const Color green500 = Color(0xFF1A9E45); // health light

  // Cyan family
  static const Color cyan400 = Color(0xFF1DE5C2); // accent cyan dark
  static const Color cyan500 = Color(0xFF0DA89A); // accent cyan light

  // Blue family
  static const Color blue300 = Color(0xFF5A94FF); // accent blue / sleep chart
  static const Color blue500 = Color(0xFF4A7BD9); // sleep dark
  static const Color blue700 = Color(0xFF2E5BB5); // sleep light

  // Purple family
  static const Color purple400 = Color(0xFF8B6AFF); // gradient end sleep
  static const Color purple500 = Color(0xFF9675DB); // project purple
  static const Color purple600 = Color(0xFF6B45CC); // sleep gradient light end
  static const Color purple700 = Color(0xFFCC3DCC); // accent pink light

  // Pink
  static const Color pink400 = Color(0xFFFF5CFF); // accent pink dark

  // Lime
  static const Color lime300 = Color(0xFFAECC35); // project lime

  // ── Semantic Status ──
  static const Color errorRed = Color(0xFFFF5C5C);
  static const Color onErrorWhite = Colors.white;

  // ── Expense Screen specific ──
  static const Color expenseBadgeBg = Color(0xFFDBFF4B);
  static const Color expenseBadgeIcon = Color(0xFF14141E);
}
