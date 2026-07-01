import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/devhub/core/navigation/main_shell.dart';
import 'package:flutter_advanced_course/devhub/features/auth/providers/auth_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/auth/screens/login_screen.dart';
import 'package:flutter_advanced_course/devhub/features/bookmarks/providers/bookmark_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/providers/feed_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/providers/filter_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/providers/search_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/settings/providers/settings_notifier.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// 🎓 LESSON — THE PROVIDER DEPENDENCY GRAPH (read this first!)
//
// This file is the most important architectural document in the project.
// The order and type of providers here defines the ENTIRE dependency graph.
//
// Dependency Graph:
//
//   ┌── AuthNotifier          ← ROOT. No deps. Owns: isLoggedIn, currentUser
//   │
//   ├── SettingsNotifier      ← ROOT. No deps. Owns: themeMode
//   │
//   ├── FilterNotifier        ← ROOT. No deps. Owns: selectedTags
//   │
//   ├── SearchNotifier        ← ROOT. No deps. Owns: searchQuery
//   │
//   ├── FeedNotifier          ← DEPENDS ON AuthNotifier (needs userId)
//   │        Created via ProxyProvider<AuthNotifier, FeedNotifier>
//   │        When auth changes → ProxyProvider.update() is called
//   │        → Either recreates FeedNotifier or returns previous
//   │
//   └── BookmarkNotifier      ← DEPENDS ON AuthNotifier (needs userId)
//            Created via ProxyProvider<AuthNotifier, BookmarkNotifier>
//            When user logs out → syncUser(null) clears all bookmarks
//
// ════════════════════════════════════════════════════════════════════════════

void main() {
  runApp(
    // 🎓 MultiProvider is the root of the widget tree.
    // All providers declared here are available to every widget below.
    // IMPORTANT: ProxyProvider consumers must come AFTER their dependencies.
    MultiProvider(
      providers: [
        // ── Layer 1: Root Providers (no dependencies) ─────────────────────
        // These can be declared in any order relative to each other.
        ChangeNotifierProvider<AuthNotifier>(create: (_) => AuthNotifier()),
        ChangeNotifierProvider<SettingsNotifier>(
          create: (_) => SettingsNotifier(),
        ),
        ChangeNotifierProvider<FilterNotifier>(create: (_) => FilterNotifier()),
        ChangeNotifierProvider<SearchNotifier>(create: (_) => SearchNotifier()),

        // ── Layer 2: Derived Providers (depend on Layer 1) ─────────────────
        // These MUST come after their dependencies in the list.
        // 🎓 This ordering requirement is one of Provider's pain points.
        //    In Riverpod, order doesn't matter — the graph is auto-resolved.
        ChangeNotifierProxyProvider<AuthNotifier, FeedNotifier>(
          // create: runs once when the provider is first accessed
          create: (ctx) =>
              FeedNotifier(userId: ctx.read<AuthNotifier>().currentUser?.id),
          // update: runs every time AuthNotifier calls notifyListeners()
          update: (ctx, auth, previous) {
            final newUserId = auth.currentUser?.id;
            // 🎓 Only recreate FeedNotifier when the actual userId changes.
            // If AuthNotifier notifies for other reasons, we return previous.
            if (previous?.userId != newUserId) {
              return FeedNotifier(userId: newUserId);
            }
            return previous!;
          },
        ),

        ChangeNotifierProxyProvider<AuthNotifier, BookmarkNotifier>(
          create: (ctx) => BookmarkNotifier(
            userId: ctx.read<AuthNotifier>().currentUser?.id,
          ),
          update: (ctx, auth, previous) {
            // 🎓 We reuse the same instance and call syncUser()
            // to update it reactively when auth changes.
            // This is different from FeedNotifier where we recreate.
            // Both approaches are valid — choice depends on whether
            // you want to preserve existing state (bookmarks) or reset it.
            previous!.syncUser(auth.currentUser?.id);
            return previous;
          },
        ),
      ],

      // 🎓 DevHubApp is the first widget that can use context.watch/read
      child: const DevHubApp(),
    ),
  );
}

class DevHubApp extends StatelessWidget {
  const DevHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎓 context.watch<SettingsNotifier>() — full watch needed here
    // because MaterialApp needs to rebuild when themeMode changes.
    final themeMode = context.watch<SettingsNotifier>().themeMode;

    // 🎓 context.select() — subscribes ONLY to the isLoggedIn bool.
    // If AuthNotifier.currentUser's username changes in the future,
    // DevHubApp will NOT rebuild (only the username display widget will).
    // This is the difference between select and watch.
    final isLoggedIn = context.select<AuthNotifier, bool>(
      (auth) => auth.isLoggedIn,
    );

    return MaterialApp(
      title: 'DevHub',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: themeMode,
      // 🎓 Auth-gating: instead of a Router, we conditionally show screens.
      // When isLoggedIn changes → this build() re-runs → home switches.
      // The state change drives navigation automatically.
      home: isLoggedIn ? const MainShell() : const LoginScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    const seedColor = Color(0xFF6366F1); // Indigo
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
    );
  }
}
