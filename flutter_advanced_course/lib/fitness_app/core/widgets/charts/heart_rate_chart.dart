import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/charts/animated_bar_chart.dart';

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
    final theme = context.heartRateChartTheme;
    final cs = context.cs;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.backgroundColor ?? cs.surface,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Heart Rate', style: theme.titleStyle),
          const Spacer(),
          Center(
            child: SizedBox(
              height: 50.0,
              width: double.infinity,
              child: AnimatedBarChart(
                dataPoints: dataPoints,
                color: theme.barColor ?? Theme.of(context).colorScheme.primary,
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
                  return Text('$value', style: theme.valueStyle);
                },
              ),
              const SizedBox(width: 4),
              Text('BPM', style: theme.unitStyle),
            ],
          ),
        ],
      ),
    );
  }
}
