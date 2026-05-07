import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import 'animated_bar_chart.dart';

class HeartRateChart extends StatelessWidget {
  final int bpm;
  final List<double> dataPoints;

  const HeartRateChart({
    super.key,
    required this.bpm,
    required this.dataPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FitnessColors.cardBackground,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Heart Rate', style: FitnessTextStyles.cardTitle),
          const Spacer(),
          Center(
            child: SizedBox(
              height: 50.0,
              width: double.infinity,
              child: AnimatedBarChart(
                dataPoints: dataPoints,
                color: FitnessColors.sleep,
              ),
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: bpm),
                duration: const Duration(milliseconds: 1400),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text('$value', style: FitnessTextStyles.chartValue);
                },
              ),
              const SizedBox(width: 4),
              const Text('BPM', style: FitnessTextStyles.cardTitle),
            ],
          ),
        ],
      ),
    );
  }
}
