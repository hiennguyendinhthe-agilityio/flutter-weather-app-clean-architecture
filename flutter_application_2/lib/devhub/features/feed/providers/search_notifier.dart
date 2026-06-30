import 'dart:async';

import 'package:flutter/foundation.dart';

// 🎓 LESSON — Ephemeral vs Shared state boundary
// The typed characters (TextField value) are LOCAL state owned by the widget.
// But when committed to a search, it becomes SHARED state (other widgets need it).
// SearchNotifier holds the "committed" query — not what's being typed right now.

class SearchNotifier extends ChangeNotifier {
  String _query = '';
  Timer? _debounce;

  String get query => _query;
  bool get hasQuery => _query.isNotEmpty;

  // 🎓 LESSON — Debounce: Don't notify on every keystroke!
  // Without debounce: typing "flutter" = 7 notifyListeners() = 7 rebuilds of PostList
  // With debounce: typing "flutter" = 1 notifyListeners() (300ms after last key)
  void setQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_query == value) {
        return; // 🎓 Avoid notify if value didn't actually change
      }
      _query = value;
      notifyListeners();
    });
  }

  void clear() {
    _debounce?.cancel();
    if (_query.isEmpty) return;
    _query = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce
        ?.cancel(); // 🎓 Always cancel timers in dispose() to avoid memory leaks
    super.dispose();
  }
}
