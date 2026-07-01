import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/devhub/features/auth/providers/auth_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/providers/feed_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/providers/filter_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/providers/search_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/feed/widgets/post_card.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// 🎓 THE MOST IMPORTANT LESSON IN THIS PROJECT — REBUILD ISOLATION
//
// FeedScreen.build() itself calls NOTHING from any provider.
// It is a pure SKELETON / ASSEMBLER widget.
//
// Each private child widget manages its OWN provider subscription.
// This means when FilterNotifier changes, ONLY _FilterSection rebuilds.
// When SearchNotifier changes, ONLY _SearchSection rebuilds.
// When FeedNotifier changes, ONLY _PostListSection rebuilds.
//
// Compare this to the naive approach:
//   class FeedScreen extends StatelessWidget {
//     Widget build(BuildContext context) {
//       final feed   = context.watch<FeedNotifier>();     // ← subscribes here
//       final filter = context.watch<FilterNotifier>();   // ← subscribes here
//       final search = context.watch<SearchNotifier>();   // ← subscribes here
//       // Now ANY change to ANY of those → ENTIRE FeedScreen rebuilds.
//       // Including the AppBar, the loading skeleton, the filter bar...
//       // This is the Rebuild Blast Radius problem.
//     }
//   }
// ════════════════════════════════════════════════════════════════════════════

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎓 FeedScreen does NOT watch anything. Zero rebuilds from state changes.
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _AppBarSection(), // Watches: AuthNotifier (username only)
            _SearchSection(), // Watches: SearchNotifier
            _FilterSection(), // Watches: FilterNotifier
            Expanded(
              child:
                  _PostListSection(), // Watches: FeedNotifier + FilterNotifier + SearchNotifier
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppBar: Only watches the username — doesn't rebuild on Filter/Search changes
// ─────────────────────────────────────────────────────────────────────────────
class _AppBarSection extends StatelessWidget {
  const _AppBarSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // 🎓 context.select() — subscribe to ONE field of AuthNotifier.
    // If AuthNotifier adds other fields and calls notifyListeners(),
    // this widget still only rebuilds when username specifically changes.
    final username = context.select<AuthNotifier, String>(
      (auth) => auth.currentUser?.username ?? '',
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back 👋',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Text(
                username,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 20,
            backgroundColor: cs.primaryContainer,
            child: Text(
              username.isNotEmpty ? username[0].toUpperCase() : 'D',
              style: TextStyle(
                color: cs.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search bar: writes to SearchNotifier, TextField is local state
// ─────────────────────────────────────────────────────────────────────────────
class _SearchSection extends StatefulWidget {
  const _SearchSection();

  @override
  State<_SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  // 🎓 The TextEditingController is LOCAL state — only this widget owns it.
  // SearchNotifier gets the debounced value AFTER typing stops.
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          // 🎓 context.read() — correct in callbacks
          // We want to WRITE to SearchNotifier, not subscribe to it.
          context.read<SearchNotifier>().setQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search posts...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: context.watch<SearchNotifier>().hasQuery
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _controller.clear();
                    context.read<SearchNotifier>().clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter chips: only rebuilds when FilterNotifier changes
// ─────────────────────────────────────────────────────────────────────────────
class _FilterSection extends StatelessWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context) {
    // 🎓 This widget subscribes to FilterNotifier ONLY.
    // When user bookmarks a post, this widget does NOT rebuild.
    final filter = context.watch<FilterNotifier>();
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: FilterNotifier.allTags.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            final hasFilter = filter.selectedTags.isNotEmpty;
            return FilterChip(
              label: const Text('All'),
              selected: !hasFilter,
              onSelected: (_) => context.read<FilterNotifier>().clearAll(),
              selectedColor: cs.primaryContainer,
            );
          }
          final tag = FilterNotifier.allTags[index - 1];
          return FilterChip(
            label: Text(tag),
            selected: filter.isSelected(tag),
            // 🎓 context.read() in onSelected — correct for event handlers
            onSelected: (_) => context.read<FilterNotifier>().toggleTag(tag),
            selectedColor: cs.primaryContainer,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Post list: the most complex section — subscribes to THREE providers
// but as a leaf widget, that's acceptable
// ─────────────────────────────────────────────────────────────────────────────
class _PostListSection extends StatelessWidget {
  const _PostListSection();

  @override
  Widget build(BuildContext context) {
    // 🎓 This leaf widget watches all three because it needs all three.
    // It IS a leaf — nothing important lives below that we don't want rebuilt.
    // So subscribing to multiple providers here is correct and efficient.
    final feed = context.watch<FeedNotifier>();
    final filter = context.watch<FilterNotifier>();
    final search = context.watch<SearchNotifier>();

    if (feed.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading posts...'),
          ],
        ),
      );
    }

    // 🎓 filteredPosts() is computed here — it's a method call, not state access.
    // No sync issues possible because there's only ONE source of truth: _allPosts.
    final posts = feed.filteredPosts(filter.selectedTags, search.query);

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 12),
            const Text('No posts found'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<FeedNotifier>().fetchPosts(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: posts.length,
        itemBuilder: (_, i) => PostCard(post: posts[i]),
      ),
    );
  }
}
