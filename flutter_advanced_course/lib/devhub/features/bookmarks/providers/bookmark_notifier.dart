import 'package:flutter/foundation.dart';

// 🎓 LESSON — Cross-feature Shared State
// BookmarkNotifier is created via ProxyProvider<AuthNotifier, BookmarkNotifier>.
// When the user logs out, syncUser(null) is called → bookmarks are cleared.
// This is REACTIVE dependency: BookmarkNotifier REACTS to AuthNotifier changes.
//
// Dependency direction (correct):
//   AuthNotifier ← BookmarkNotifier watches/reacts to
//   NOT: AuthNotifier → calls BookmarkNotifier.clear()  ← that's a violation!

class BookmarkNotifier extends ChangeNotifier {
  String? _userId;
  final Set<String> _bookmarkedIds = {};

  BookmarkNotifier({required String? userId}) : _userId = userId;

  // Returns an unmodifiable view — external code cannot mutate the set directly
  Set<String> get bookmarkedIds => Set.unmodifiable(_bookmarkedIds);

  bool isBookmarked(String postId) => _bookmarkedIds.contains(postId);

  // 🎓 This is called by ProxyProvider.update() when AuthNotifier changes
  void syncUser(String? newUserId) {
    if (_userId == newUserId) return; // No change, no rebuild
    _userId = newUserId;

    if (newUserId == null) {
      // User logged out → clear all bookmarks
      _bookmarkedIds.clear();
    } else {
      // User logged in → could load bookmarks from storage here
      _bookmarkedIds.clear();
    }
    notifyListeners();
  }

  void toggle(String postId) {
    if (_bookmarkedIds.contains(postId)) {
      _bookmarkedIds.remove(postId);
    } else {
      _bookmarkedIds.add(postId);
    }
    notifyListeners();
    // 🎓 QUESTION: What rebuilds here?
    // Only widgets that subscribed to BookmarkNotifier.
    // With Selector<BookmarkNotifier, bool>(selector: (_, bm) => bm.isBookmarked(id))
    // ONLY the bookmark icon for THIS specific postId rebuilds.
    // The rest of the PostCard does NOT rebuild. This is precision rebuilding.
  }

  int get count => _bookmarkedIds.length;
}
