// Layer 3: Theme State — Riverpod Notifier.
//
// Manages [ThemeMode] as app-level state.
// Exposes a simple toggle API. Persists nothing in this iteration
// (persistence can be added later without changing the public API).
//
// Rules:
//   - State type: [ThemeMode] (Flutter-native, no custom wrapper needed).
//   - Default: [ThemeMode.system] — respects user's OS preference.
//   - Provider is annotated so code-gen can run if needed in future.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that owns and mutates the app's [ThemeMode].
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system; // Default: follow OS

  /// Cycle through: system → light → dark → system.
  void cycle() {
    state = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
  }

  /// Set an explicit [ThemeMode].
  void setMode(ThemeMode mode) => state = mode;

  /// Toggle between light and dark (ignores system).
  void toggleLightDark() {
    state = state == ThemeMode.light ? ThemeMode.light : ThemeMode.dark;
  }
}

/// Global provider — use [ref.watch(themeModeProvider)] in widgets,
/// [ref.read(themeModeProvider.notifier)] to mutate.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
