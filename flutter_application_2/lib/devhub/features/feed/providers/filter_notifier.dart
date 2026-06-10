import 'package:flutter/foundation.dart';

// 🎓 LESSON — Shared State with no dependencies
// FilterNotifier lives at the same level as AuthNotifier in the tree.
// It does NOT depend on any other notifier.
// Owner: FilterNotifier
// Consumers: _FilterBarWidget (to render chips), _PostListSection (to filter)
// Lifetime: Lives while the app is running — survives screen navigation

class FilterNotifier extends ChangeNotifier {
  // 🎓 Using a Set<String> ensures no duplicate tags
  // The Set is private — external code gets an unmodifiable view
  final Set<String> _selectedTags = {};

  Set<String> get selectedTags => Set.unmodifiable(_selectedTags);

  bool isSelected(String tag) => _selectedTags.contains(tag);

  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    notifyListeners();
    // 🎓 QUESTION: What rebuilds after this?
    // Answer: Every widget that called context.watch<FilterNotifier>()
    // or used Selector<FilterNotifier, ...>() will be marked dirty.
    // The _PostListSection and _FilterBarWidget will rebuild.
    // The FeedScreen itself will NOT rebuild (it watches nothing).
  }

  void clearAll() {
    if (_selectedTags.isEmpty) return; // 🎓 Avoid unnecessary notifyListeners()
    _selectedTags.clear();
    notifyListeners();
  }

  // All available tags in the app
  static const List<String> allTags = [
    'Flutter',
    'Dart',
    'State',
    'Architecture',
    'Performance',
    'UI',
    'Internals',
    'BLoC',
    'Riverpod',
  ];
}
