import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/health_stats_data.dart';

class ActivityLevelsList extends StatelessWidget {
  final List<ActivityLevelData> activities;

  const ActivityLevelsList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Activity levels',
                style: FitnessTextStyles.sectionHeader,
              ),
              const Spacer(),
              const Icon(
                Icons.play_arrow_rounded,
                color: FitnessColors.textPrimary,
                size: 24,
              ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: FitnessColors.activityCardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: FitnessColors.activityCardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: FitnessColors.activity,
            ),
            child: Center(
              child: Icon(
                activity.icon,
                color: FitnessColors.activityCardBg,
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(activity.name, style: FitnessTextStyles.activityName),
          ),

          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: activity.percentage / 100,
                  backgroundColor: FitnessColors.cardBorder,
                  color: FitnessColors.textPrimary,
                  strokeWidth: 2.0,
                ),
                Text(
                  '${activity.percentage.toInt()}%',
                  style: FitnessTextStyles.activityPercent.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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
