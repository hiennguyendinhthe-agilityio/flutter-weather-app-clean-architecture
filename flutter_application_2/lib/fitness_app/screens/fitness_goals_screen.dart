import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/daily_fitness_data.dart';
import '../repositories/fitness_repository.dart';
import '../widgets/charts/heart_rate_chart.dart';
import '../widgets/charts/nested_rings_chart.dart';
import '../widgets/charts/steps_gauge_chart.dart';
import '../widgets/fitness/weekly_calendar.dart';

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

  PreferredSizeWidget get _appBar => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: FitnessColors.textPrimary,
        size: 20,
      ),
      onPressed: () => Navigator.maybePop(context),
    ),
    title: const Text('Fitness goals', style: FitnessTextStyles.titleLarge),
    centerTitle: true,
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
  );

  @override
  Widget build(BuildContext context) {
    final currentDayData = _weekData[_selectedDayIndex];

    return Scaffold(
      backgroundColor: FitnessColors.background,
      appBar: _appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              WeeklyCalendar(
                selectedIndex: _selectedDayIndex,
                onDaySelected: (index) {
                  setState(() {
                    _selectedDayIndex = index;
                  });
                },
              ),

              const SizedBox(height: 48),

              _buildRingsChart(currentDayData),

              const SizedBox(height: 40),

              _buildBottomCards(currentDayData),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
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
