import 'package:flutter/material.dart';

import '../models/daily_fitness_data.dart';
import '../repositories/fitness_repository.dart';
import '../theme/theme_context_ext.dart';
import '../widgets/charts/heart_rate_chart.dart';
import '../widgets/charts/nested_rings_chart.dart';
import '../widgets/charts/steps_gauge_chart.dart';
import '../widgets/fitness/weekly_calendar.dart';

const double _kExpandedHeight = 160.0;

class FitnessGoalsScreen extends StatefulWidget {
  const FitnessGoalsScreen({super.key});

  @override
  State<FitnessGoalsScreen> createState() => _FitnessGoalsScreenState();
}

class _FitnessGoalsScreenState extends State<FitnessGoalsScreen> {
  final ValueNotifier<int> _selectedDayNotifier = ValueNotifier<int>(3);

  late final List<DailyFitnessData> _weekData;

  @override
  void initState() {
    super.initState();
    _weekData = FitnessRepository.getCurrentWeekData();
  }

  @override
  void dispose() {
    _selectedDayNotifier.dispose();
    super.dispose();
  }

  Widget _buildFlexibleSpace(BuildContext context) {
    final ft = context.fitnessTheme;
    return FlexibleSpaceBar(
      background: Container(
        color: ft.scaffoldBackground,
        padding: const EdgeInsets.only(
          top: 56.0,
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
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: ft.activityColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://i.pravatar.cc/150?img=44',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        color: ft.scaffoldBackground,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Good morning 👋',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: ft.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Alex Johnson',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ft.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ft.cardBackground,
                    border: Border.all(color: ft.cardBorder, width: 1.0),
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: ft.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: ft.activityColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ft.activityColor.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                '🏆  Weekly goal: 5 workouts',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ft.activityColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ft = context.fitnessTheme;

    return Scaffold(
      backgroundColor: ft.scaffoldBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: _kExpandedHeight,

            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today_rounded, size: 20),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: _buildFlexibleSpace(context),
          ),

          SliverToBoxAdapter(
            child: ValueListenableBuilder<int>(
              valueListenable: _selectedDayNotifier,
              builder: (context, selectedDay, _) {
                return WeeklyCalendar(
                  selectedIndex: selectedDay,
                  onDaySelected: (index) {
                    _selectedDayNotifier.value = index;
                  },
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),

          SliverToBoxAdapter(
            child: ValueListenableBuilder<int>(
              valueListenable: _selectedDayNotifier,
              builder: (context, selectedDay, _) {
                final dayData = _weekData[selectedDay];
                return Column(
                  children: [
                    RepaintBoundary(
                      child: NestedRingsChart(
                        size: 250.0,
                        spacing: 12.0,
                        rings: [
                          NestedRingData(
                            progress: dayData.activityProgress,
                            color: ft.activityColor,
                            trackColor: ft.activityColor,
                            label: 'Activity',
                            icon: Icons.bolt_rounded,
                            strokeWidth: 8.0,
                          ),
                          NestedRingData(
                            progress: dayData.healthProgress,
                            color: ft.healthColor,
                            trackColor: ft.healthColor,
                            label: 'Health',
                            icon: Icons.favorite_rounded,
                            strokeWidth: 12.0,
                          ),
                          NestedRingData(
                            progress: dayData.sleepProgress,
                            color: ft.sleepColor,
                            trackColor: ft.sleepColor,
                            label: 'Sleep',
                            icon: Icons.bedtime_rounded,
                            strokeWidth: 16.0,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 220,
                              child: RepaintBoundary(
                                child: StepsGaugeChart(
                                  currentSteps: dayData.currentSteps,
                                  goalSteps: dayData.goalSteps,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 220,
                              child: RepaintBoundary(
                                child: HeartRateChart(
                                  bpm: dayData.bpm,
                                  dataPoints: dayData.heartRateDataPoints,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}
