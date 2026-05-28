import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/fitness_provider.dart';
import '../providers/fitness_insight_provider.dart';
import '../../../core/widgets/fitness/fitness_summary_card.dart';
import '../../../core/theme/theme_context_ext.dart';
import '../../../core/widgets/charts/fitness_activity_rings.dart';
import '../../../core/widgets/fitness/activity_levels_list.dart';
import '../../../core/widgets/fitness/user_profile_header.dart';
import '../../../core/widgets/common/fitness_loading_widget.dart';
import '../../../core/widgets/common/fitness_error_widget.dart';

class HealthStatsScreen extends ConsumerWidget {
  const HealthStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.cs;
    final healthStatsAsync = ref.watch(healthStatsProvider);
    final fitnessInsightAsync = ref.watch(fitnessInsightProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Stats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(healthStatsProvider);
              ref.invalidate(currentWeekDataProvider);
            },
          ),
          IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: healthStatsAsync.when(
          loading: () => const FitnessLoadingWidget(message: 'Đang tải thông tin sức khỏe...'),
          error: (error, stack) => FitnessErrorWidget(
            message: error.toString(),
            onRetry: () => ref.invalidate(healthStatsProvider),
          ),
          data: (currentData) => CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              SliverToBoxAdapter(
                child: UserProfileHeader(
                  monthYear: 'June 2022',
                  subtitle: currentData.motivationalText,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RepaintBoundary(
                    child: ActivityRingsChart(
                      size: 280.0,
                      spacing: 14.0,
                      totalIndex: currentData.totalIndex,
                      rings: [
                        ActivityRingsData(
                          progress: currentData.healthProgress,
                          color: cs.secondary,
                          label: 'Health',
                          icon: Icons.favorite_rounded,
                          strokeWidth: 16.0,
                        ),
                        ActivityRingsData(
                          progress: currentData.sleepProgress,
                          color: cs.tertiary,
                          label: 'Sleep',
                          icon: Icons.bedtime_rounded,
                          strokeWidth: 16.0,
                        ),
                        ActivityRingsData(
                          progress: currentData.activityProgress,
                          color: cs.primary,
                          label: 'Activity',
                          icon: Icons.bolt_rounded,
                          strokeWidth: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 36)),

              SliverToBoxAdapter(
                child: fitnessInsightAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                  data: (insight) => FitnessSummaryCard(insight: insight),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 36)),

              SliverToBoxAdapter(
                child: ActivityLevelsList(
                  activities: currentData.activityLevels,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }
}
