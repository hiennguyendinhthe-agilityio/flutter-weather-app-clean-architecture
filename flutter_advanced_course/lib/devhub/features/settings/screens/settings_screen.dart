import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/devhub/features/auth/providers/auth_notifier.dart';
import 'package:flutter_advanced_course/devhub/features/settings/providers/settings_notifier.dart';
import 'package:provider/provider.dart';

// 🎓 LESSON — context.read() vs context.watch() in one screen
// SettingsScreen uses BOTH:
//   - context.watch<SettingsNotifier>() → to reactively show current theme switch state
//   - context.read<AuthNotifier>().logout() → to fire logout, no subscription needed

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // 🎓 We WATCH settings here because we want the Switch to reflect current state
    final settings = context.watch<SettingsNotifier>();
    // 🎓 We READ auth here — we only need to call logout(), no subscription
    final auth = context.read<AuthNotifier>();

    final user = context.select<AuthNotifier, String>(
      (a) => a.currentUser?.username ?? '',
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 20),
            Text(
              'Settings',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 24),

            // ── Profile Card ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: cs.primaryContainer,
                    child: Text(
                      user.isNotEmpty ? user[0].toUpperCase() : 'D',
                      style: TextStyle(
                        fontSize: 24,
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'dev@devhub.io',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Appearance',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // ── Theme toggle tile ──
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: SwitchListTile(
                secondary: Icon(
                  settings.isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: cs.primary,
                ),
                title: const Text('Dark Mode'),
                subtitle: Text(
                  settings.isDark ? 'Currently dark' : 'Currently light',
                ),
                value: settings.isDark,
                // 🎓 context.read() in the callback — correct!
                // We already watch settings above via context.watch.
                // No need to subscribe again inside onChanged.
                onChanged: (_) =>
                    context.read<SettingsNotifier>().toggleTheme(),
                activeThumbColor: cs.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'State Management Info',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // ── Info cards explaining what each provider does ──
            const _InfoCard(
              icon: Icons.lock_outline_rounded,
              title: 'AuthNotifier',
              description:
                  'Root provider. Owns isLoggedIn + currentUser. '
                  'FeedNotifier and BookmarkNotifier depend on this.',
            ),
            const SizedBox(height: 8),
            const _InfoCard(
              icon: Icons.article_outlined,
              title: 'FeedNotifier',
              description:
                  'Created via ProxyProvider<AuthNotifier>. '
                  'Stores _allPosts. filteredPosts() is a computed method, not stored state.',
            ),
            const SizedBox(height: 8),
            const _InfoCard(
              icon: Icons.filter_list_rounded,
              title: 'FilterNotifier + SearchNotifier',
              description:
                  'Independent notifiers. When changed, only '
                  '_FilterSection and _PostListSection rebuild — not the whole screen.',
            ),
            const SizedBox(height: 8),
            const _InfoCard(
              icon: Icons.bookmark_outline_rounded,
              title: 'BookmarkNotifier',
              description:
                  'Uses Selector in PostCard so ONLY the bookmark '
                  'icon of the toggled post rebuilds. Zero wasted renders.',
            ),

            const SizedBox(height: 32),

            // ── Logout button ──
            OutlinedButton.icon(
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.error,
                side: BorderSide(color: cs.error.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // 🎓 context.read() — correct in event handlers
              // After logout(), AuthNotifier calls notifyListeners()
              // → DevHubApp's context.select(isLoggedIn) sees the change
              // → LoginScreen is shown automatically
              onPressed: () => auth.logout(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
