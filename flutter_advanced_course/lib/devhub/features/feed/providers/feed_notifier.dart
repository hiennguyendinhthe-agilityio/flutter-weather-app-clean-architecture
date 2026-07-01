import 'package:flutter/foundation.dart';
import 'package:flutter_advanced_course/devhub/features/feed/models/post_model.dart';

// 🎓 LESSON — ProxyProvider & Async State
// FeedNotifier DEPENDS on Auth (needs userId to know whose feed to load).
// It is created via ProxyProvider<AuthNotifier, FeedNotifier> in main_devhub.dart.
// When auth changes (login/logout), ProxyProvider calls update() and recreates this.
//
// State lifecycle:
//   - Created: when user logs in (ProxyProvider.update sees new userId)
//   - Alive: while user is logged in and FeedScreen is visible
//   - Destroyed: when user logs out (ProxyProvider.update creates a new instance)

class FeedNotifier extends ChangeNotifier {
  final String? userId;

  FeedNotifier({required this.userId}) {
    if (userId != null) fetchPosts();
  }

  List<Post> _allPosts = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 🎓 KEY LESSON — Derived State is a METHOD, NOT a stored field.
  //
  // ❌ WRONG approach (two sources of truth):
  //   List<Post> _filteredPosts = [];  ← stored separately → sync problems
  //   void applyFilter(tags) { _filteredPosts = ...; notifyListeners(); }
  //
  // ✅ CORRECT approach (single source of truth):
  //   _allPosts is the ONLY stored state.
  //   filteredPosts() is a pure function that computes from _allPosts.
  List<Post> filteredPosts(Set<String> tags, String query) {
    var result = _allPosts;

    if (tags.isNotEmpty) {
      result = result.where((p) => p.tags.any(tags.contains)).toList();
    }

    if (query.isNotEmpty) {
      final lower = query.toLowerCase();
      result = result
          .where(
            (p) =>
                p.title.toLowerCase().contains(lower) ||
                p.excerpt.toLowerCase().contains(lower) ||
                p.authorName.toLowerCase().contains(lower),
          )
          .toList();
    }

    return result;
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    _allPosts = _mockPosts;
    _isLoading = false;
    notifyListeners();
  }

  // Mock data — in a real app this comes from a Repository
  static const List<Post> _mockPosts = [
    Post(
      id: 'p1',
      authorName: 'Remi Rousselet',
      title: 'Why I Created Riverpod',
      excerpt:
          'Provider was great, but its dependency on BuildContext was a fundamental limitation that forced bad patterns...',
      tags: ['Flutter', 'Riverpod', 'State'],
      likesCount: 2400,
      commentsCount: 87,
    ),
    Post(
      id: 'p2',
      authorName: 'Felix Angelov',
      title: 'BLoC Pattern in 2024',
      excerpt:
          'BLoC is still an excellent choice for large teams. Explicit events and states make reasoning about code trivial...',
      tags: ['Flutter', 'BLoC', 'Architecture'],
      likesCount: 1850,
      commentsCount: 124,
    ),
    Post(
      id: 'p3',
      authorName: 'Filip Hracek',
      title: 'InheritedWidget: The Hidden Foundation',
      excerpt:
          'Every state management solution in Flutter — Provider, Riverpod, BLoC — sits on top of InheritedWidget...',
      tags: ['Flutter', 'State', 'Internals'],
      likesCount: 3200,
      commentsCount: 201,
    ),
    Post(
      id: 'p4',
      authorName: 'Eric Seidel',
      title: 'Custom Slivers: Full Control Over Scroll',
      excerpt:
          'Slivers give you fine-grained control over scroll physics and painting. Understand them once, use them forever...',
      tags: ['Flutter', 'UI', 'Performance'],
      likesCount: 980,
      commentsCount: 45,
    ),
    Post(
      id: 'p5',
      authorName: 'Chris Sells',
      title: 'Feature-First vs Layer-First Architecture',
      excerpt:
          'The feature-first debate never ends. But after shipping 20+ apps, the answer is clear: features win at scale...',
      tags: ['Flutter', 'Architecture'],
      likesCount: 1560,
      commentsCount: 98,
    ),
    Post(
      id: 'p6',
      authorName: 'Emily Fortuna',
      title: 'Dart Null Safety: Under the Hood',
      excerpt:
          'How does the Dart compiler enforce null safety at the type system level? The answer involves flow analysis...',
      tags: ['Dart', 'Internals'],
      likesCount: 2100,
      commentsCount: 156,
    ),
    Post(
      id: 'p7',
      authorName: 'Andrew Brogdon',
      title: 'Eliminating Jank with DevTools',
      excerpt:
          'The Flutter Performance overlay and DevTools timeline view are underused. Here is how to find every frame drop...',
      tags: ['Flutter', 'Performance'],
      likesCount: 1350,
      commentsCount: 67,
    ),
    Post(
      id: 'p8',
      authorName: 'Majid Hajian',
      title: 'Clean Architecture Boundaries in Flutter',
      excerpt:
          'Domain, data, and presentation layers need hard boundaries. Here is how to enforce them with Dart imports...',
      tags: ['Flutter', 'Architecture'],
      likesCount: 890,
      commentsCount: 43,
    ),
  ];
}
