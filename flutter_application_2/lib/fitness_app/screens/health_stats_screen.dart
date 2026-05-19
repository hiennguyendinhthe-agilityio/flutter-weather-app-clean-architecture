import 'package:flutter/material.dart';

import '../models/health_stats_data.dart';
import '../repositories/fitness_repository.dart';
import '../theme/theme_context_ext.dart';
import '../widgets/charts/fitness_activity_rings.dart';
import '../widgets/fitness/activity_levels_list.dart';
import '../widgets/fitness/user_profile_header.dart';

class HealthStatsScreen extends StatefulWidget {
  const HealthStatsScreen({super.key});

  @override
  State<HealthStatsScreen> createState() => _HealthStatsScreenState();
}

class _HealthStatsScreenState extends State<HealthStatsScreen> {
  late final HealthStatsData _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = FitnessRepository.getCurrentHealthStats();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Stats'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverToBoxAdapter(
              child: UserProfileHeader(
                monthYear: 'June 2022',
                subtitle: _currentData.motivationalText,
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
                    totalIndex: _currentData.totalIndex,
                    rings: [
                      ActivityRingsData(
                        progress: _currentData.healthProgress,
                        color: cs.secondary,
                        label: 'Health',
                        icon: Icons.favorite_rounded,
                        strokeWidth: 16.0,
                      ),
                      ActivityRingsData(
                        progress: _currentData.sleepProgress,
                        color: cs.tertiary,
                        label: 'Sleep',
                        icon: Icons.bedtime_rounded,
                        strokeWidth: 16.0,
                      ),
                      ActivityRingsData(
                        progress: _currentData.activityProgress,
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
              child: ActivityLevelsList(
                activities: _currentData.activityLevels,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}
