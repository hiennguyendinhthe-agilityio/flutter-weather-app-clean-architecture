import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/daily_fitness_data.dart';
import '../repositories/fitness_repository.dart';
import '../widgets/charts/heart_rate_chart.dart';
import '../widgets/charts/nested_rings_chart.dart';
import '../widgets/charts/steps_gauge_chart.dart';
import '../widgets/fitness/weekly_calendar.dart';

// ── Expanded height for the SliverAppBar flexible space ──
const double _kExpandedHeight = 160.0;

class FitnessGoalsScreen extends StatefulWidget {
  const FitnessGoalsScreen({super.key});

  @override
  State<FitnessGoalsScreen> createState() => _FitnessGoalsScreenState();
}

class _FitnessGoalsScreenState extends State<FitnessGoalsScreen> {
  int _selectedDayIndex = 3;
  late final List<DailyFitnessData> _weekData;

  @override
  void initState() {
    super.initState();
    _weekData = FitnessRepository.getCurrentWeekData();
  }

  // ── SliverAppBar flexible space: expands to show user profile ──
  Widget _buildFlexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      // Title shown only when collapsed (SliverAppBar is pinned)
      // title: const Text('Fitness Goals', style: FitnessTextStyles.titleLarge),
      // titlePadding: const EdgeInsetsDirectional.only(start: 52, bottom: 16),
      // Background shown when expanded
      background: Container(
        color: FitnessColors.background,
        padding: const EdgeInsets.only(
          top: 56.0, // clears status bar
          left: 20.0,
          right: 20.0,
          bottom: 6.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE03E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://i.pravatar.cc/150?img=44',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        color: Color(0xFF14141E),
                        size: 28,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Greeting + month
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Good morning 👋',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: FitnessColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Alex Johnson',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: FitnessColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FitnessColors.cardBackground,
                    border: Border.all(
                      color: FitnessColors.cardBorder,
                      width: 1.0,
                    ),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: FitnessColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Motivational tag line
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: FitnessColors.activity.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: FitnessColors.activity.withValues(alpha: 0.25),
                ),
              ),
              child: const Text(
                '🏆  Weekly goal: 5 workouts',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: FitnessColors.activity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRingsChart(DailyFitnessData dayData) {
    return NestedRingsChart(
      size: 250.0,
      spacing: 12.0,
      rings: [
        NestedRingData(
          progress: dayData.activityProgress,
          color: FitnessColors.activity,
          trackColor: FitnessColors.activityTrack,
          label: 'Activity',
          icon: Icons.bolt_rounded,
          strokeWidth: 8.0,
        ),
        NestedRingData(
          progress: dayData.healthProgress,
          color: FitnessColors.health,
          trackColor: FitnessColors.healthTrack,
          label: 'Health',
          icon: Icons.favorite_rounded,
          strokeWidth: 12.0,
        ),
        NestedRingData(
          progress: dayData.sleepProgress,
          color: FitnessColors.sleep,
          trackColor: FitnessColors.sleepTrack,
          label: 'Sleep',
          icon: Icons.bedtime_rounded,
          strokeWidth: 16.0,
        ),
      ],
    );
  }

  Widget _buildBottomCards(DailyFitnessData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 220,
              child: StepsGaugeChart(
                currentSteps: data.currentSteps,
                goalSteps: data.goalSteps,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 220,
              child: HeartRateChart(
                bpm: data.bpm,
                dataPoints: data.heartRateDataPoints,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDayData = _weekData[_selectedDayIndex];

    return Scaffold(
      backgroundColor: FitnessColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── 1. SliverAppBar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: _kExpandedHeight,
            backgroundColor: FitnessColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            // Hide the leading back button (this is a root tab screen)
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.calendar_today_rounded,
                  color: FitnessColors.textPrimary,
                  size: 20,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: _buildFlexibleSpace(context),
          ),

          // ── 2. Weekly Calendar ───────────────────────────────────
          SliverToBoxAdapter(
            child: WeeklyCalendar(
              selectedIndex: _selectedDayIndex,
              onDaySelected: (index) {
                setState(() {
                  _selectedDayIndex = index;
                });
              },
            ),
          ),

          // ── 3. Spacing ───────────────────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: 40)),

          // ── 4. Nested Rings Chart ────────────────────────────────
          SliverToBoxAdapter(child: _buildRingsChart(currentDayData)),

          // ── 5. Spacing ───────────────────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: 40)),

          // ── 6. Bottom Stats Cards (Steps + Heart Rate) ───────────
          SliverToBoxAdapter(child: _buildBottomCards(currentDayData)),

          // ── 7. Bottom padding ────────────────────────────────────
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}
