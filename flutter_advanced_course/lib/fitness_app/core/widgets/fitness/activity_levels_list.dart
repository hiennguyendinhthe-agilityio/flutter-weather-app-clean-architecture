import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/features/stats/models/health_stats_data.dart';
import 'package:go_router/go_router.dart';

class ActivityLevelsList extends StatelessWidget {
  final List<ActivityLevelData> activities;

  const ActivityLevelsList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final theme = context.activityLevelsListTheme;
    final cs = context.cs;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Activity levels', style: theme.titleStyle),
              const Spacer(),
              Icon(Icons.play_arrow_rounded, color: cs.onSurface, size: 24),
            ],
          ),

          const SizedBox(height: 16),

          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: _ActivityLevelTile(activity: activity),
            );
          }),
        ],
      ),
    );
  }
}

class _ActivityLevelTile extends StatelessWidget {
  final ActivityLevelData activity;

  const _ActivityLevelTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = context.activityLevelsListTheme;
    final cs = context.cs;
    return GestureDetector(
      onTap: () {
        context.push('/analytics/activity', extra: activity);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: theme.iconBackgroundColor ?? cs.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: cs.outlineVariant, width: 0.5),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'activity_icon_${activity.name}',
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.iconBackgroundColor ?? cs.primary,
                ),
                child: Center(
                  child: Icon(
                    activity.icon,
                    color: theme.iconColor ?? cs.onPrimary,
                    size: 22,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(child: Text(activity.name, style: theme.titleStyle)),

            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: activity.percentage / 100,
                    backgroundColor: cs.outlineVariant,
                    color: cs.onSurface,
                    strokeWidth: 2.0,
                  ),
                  Text(
                    '${activity.percentage.toInt()}%',
                    style: theme.durationStyle?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
