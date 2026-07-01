import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/devhub/features/bookmarks/providers/bookmark_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/providers/feed_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/widgets/post_card.dart';
import 'package:provider/provider.dart';

// 🎓 LESSON — Cross-feature State Consumption
// BookmarksScreen consumes state from TWO different features:
//   1. BookmarkNotifier  (bookmarks feature) → which post IDs are saved
//   2. FeedNotifier      (feed feature)      → the full post objects
//
// BookmarksScreen does NOT own any state.
// It only READS and DISPLAYS. This is correct architecture:
// state lives in notifiers, screens only render.

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎓 Here we need BOTH notifiers. Using Consumer2 to watch both.
    // Rebuilds when EITHER bookmarks set OR the posts list changes.
    return Consumer2<BookmarkNotifier, FeedNotifier>(
      builder: (context, bookmarks, feed, _) {
        final bookmarkedPosts = feed
            // filteredPosts with no filters = all posts
            .filteredPosts({}, '')
            .where((p) => bookmarks.isBookmarked(p.id))
            .toList();

        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Row(
                    children: [
                      Text(
                        'Bookmarks',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 10),
                      // 🎓 Selector for the badge count — only rebuilds
                      // when the NUMBER of bookmarks changes, not when
                      // the IDs inside change (unless count changes too)
                      Selector<BookmarkNotifier, int>(
                        selector: (_, bm) => bm.count,
                        builder: (_, count, _) => count > 0
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                if (bookmarkedPosts.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 64,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No bookmarks yet',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the bookmark icon on any post',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: bookmarkedPosts.length,
                      itemBuilder: (_, i) => PostCard(post: bookmarkedPosts[i]),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
