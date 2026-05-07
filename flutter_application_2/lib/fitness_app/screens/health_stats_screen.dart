import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/health_stats_data.dart';
import '../repositories/fitness_repository.dart';
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
    return Scaffold(
      backgroundColor: FitnessColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: FitnessColors.textPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Health Stats', style: FitnessTextStyles.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_month,
              color: FitnessColors.textPrimary,
              size: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── 1. User Profile Header ──
              UserProfileHeader(
                monthYear: 'June 2022',
                subtitle: _currentData.motivationalText,
              ),

              const SizedBox(height: 32),

              // ── 2. Gradient Rings Chart + Total Index ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ActivityRingsChart(
                  size: 280.0,
                  spacing: 14.0,
                  totalIndex: _currentData.totalIndex,
                  rings: [
                    // Inner → Outer order (index 0 = innermost)
                    ActivityRingsData(
                      progress: _currentData.healthProgress,
                      color: FitnessColors.health,
                      label: 'Health',
                      icon: Icons.favorite_rounded,
                      strokeWidth: 16.0,
                    ),
                    ActivityRingsData(
                      progress: _currentData.sleepProgress,
                      color: FitnessColors.sleep,
                      label: 'Sleep',
                      icon: Icons.bedtime_rounded,
                      strokeWidth: 16.0,
                    ),
                    ActivityRingsData(
                      progress: _currentData.activityProgress,
                      color: FitnessColors.activity,
                      label: 'Activity',
                      icon: Icons.bolt_rounded,
                      strokeWidth: 16.0,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // ── 3. Activity Levels List ──
              ActivityLevelsList(activities: _currentData.activityLevels),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
