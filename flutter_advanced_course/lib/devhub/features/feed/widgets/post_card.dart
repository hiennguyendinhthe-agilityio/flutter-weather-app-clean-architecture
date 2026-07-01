import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/devhub/features/bookmarks/providers/bookmark_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/models/post_model.dart';
import 'package:provider/provider.dart';

// 🎓 LESSON — Rebuild Precision with Selector
// PostCard receives the full Post object, but it does NOT watch any provider.
// The ONLY provider subscription inside PostCard is the bookmark icon —
// and it uses Selector to subscribe ONLY to whether THIS postId is bookmarked.
//
// Result: When you bookmark post "p3", only the _BookmarkButton of post "p3"
// rebuilds. All other PostCards on screen are untouched. Zero wasted renders.

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // 🎓 PostCard.build() itself does NOT call context.watch or context.read.
    // It delegates provider access to its leaf child (_BookmarkButton).
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    post.authorName[0],
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    post.authorName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // 🎓 KEY: Only this tiny widget subscribes to BookmarkNotifier
                _BookmarkButton(postId: post.id),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              post.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 6),

            // Excerpt
            Text(
              post.excerpt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            // Tags
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: post.tags.map((tag) => _TagChip(tag: tag)).toList(),
            ),

            const SizedBox(height: 12),

            // Stats row
            Row(
              children: [
                Icon(
                  Icons.favorite_outline_rounded,
                  size: 16,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.likesCount}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.commentsCount}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 🎓 LESSON — Selector: Subscribe to a SLICE of state
// This widget only rebuilds when bm.isBookmarked(postId) CHANGES VALUE.
// It does NOT rebuild when other posts are bookmarked or when unrelated state changes.
// Compare this to context.watch<BookmarkNotifier>() which would rebuild on ANY change.
class _BookmarkButton extends StatelessWidget {
  final String postId;
  const _BookmarkButton({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Selector<BookmarkNotifier, bool>(
      // selector extracts ONE boolean from BookmarkNotifier
      // Selector only rebuilds when this boolean CHANGES (false→true or true→false)
      selector: (_, bm) => bm.isBookmarked(postId),
      builder: (context, isBookmarked, _) {
        return IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(
            isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            size: 20,
            color: isBookmarked
                ? Theme.of(context).colorScheme.primary
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          // 🎓 context.read() in onPressed — correct! We don't need to watch here.
          onPressed: () => context.read<BookmarkNotifier>().toggle(postId),
        );
      },
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  static const _colors = {
    'Flutter': Color(0xFF54C5F8),
    'Dart': Color(0xFF00C4B4),
    'State': Color(0xFFFF8A65),
    'Architecture': Color(0xFFBA68C8),
    'Performance': Color(0xFFFFD54F),
    'UI': Color(0xFF81C784),
    'Internals': Color(0xFFE57373),
    'BLoC': Color(0xFF64B5F6),
    'Riverpod': Color(0xFF4FC3F7),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[tag] ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
