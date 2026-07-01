import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/devhub/features/bookmarks/providers/bookmark_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/bookmarks/screens/bookmarks_screen.dart';
import 'package:flutter_advanced_course/devhub/features/feed/screens/feed_screen.dart';
import 'package:flutter_advanced_course/devhub/features/settings/screens/settings_screen.dart';
import 'package:provider/provider.dart';

// 🎓 LESSON — Navigation Shell & State Persistence
// MainShell uses IndexedStack to keep all tabs alive simultaneously.
// This means FeedScreen, BookmarksScreen, SettingsScreen are ALL mounted —
// their state (scroll position, etc.) persists when switching tabs.
//
// Alternative: PageView or Navigator per-tab.
// IndexedStack is simplest for tab state persistence.

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // 🎓 _currentIndex is LOCAL state — only this shell widget cares about
  // which tab is active. It should NOT be in a global Provider.
  int _currentIndex = 0;

  static const _screens = [FeedScreen(), BookmarksScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article_rounded),
            label: 'Feed',
          ),
          const NavigationDestination(
            icon: _BookmarksBadge(isSelected: false),
            selectedIcon: _BookmarksBadge(isSelected: true),
            label: 'Bookmarks',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// 🎓 LESSON — Selector for a navigation badge
// This small widget subscribes to BookmarkNotifier count.
// Only rebuilds when the COUNT changes — not on every bookmark toggle if count stays same.
// The rest of NavigationBar is NOT affected.
class _BookmarksBadge extends StatelessWidget {
  final bool isSelected;
  const _BookmarksBadge({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Selector<BookmarkNotifier, int>(
      selector: (_, bm) => bm.count,
      builder: (context, count, _) {
        return Badge(
          isLabelVisible: count > 0,
          label: Text('$count'),
          child: Icon(
            isSelected ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          ),
        );
      },
    );
  }
}
