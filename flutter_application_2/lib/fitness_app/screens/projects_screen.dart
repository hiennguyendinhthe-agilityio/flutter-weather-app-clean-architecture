import 'package:flutter/material.dart';

import '../models/project_data.dart';
import '../repositories/project_repository.dart';
import '../theme/theme_context_ext.dart';
import '../widgets/charts/project_horizontal_bar.dart';
import '../widgets/charts/segmented_donut_chart.dart';
import '../widgets/common/sliding_toggle.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<String> _periodNotifier;
  late final ValueNotifier<ProjectSummary> _summaryNotifier;

  late AnimationController _animationController;
  late Animation<double> _allDrawAnimation;

  @override
  void initState() {
    super.initState();
    _periodNotifier = ValueNotifier<String>('Week');
    _summaryNotifier = ValueNotifier<ProjectSummary>(
      ProjectRepository.getSummary(_periodNotifier.value),
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _allDrawAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _periodNotifier.dispose();
    _summaryNotifier.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(String period) {
    if (_periodNotifier.value != period) {
      _periodNotifier.value = period;
      _summaryNotifier.value = ProjectRepository.getSummary(period);
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final tt = context.tt;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Projects',
                  style: tt.headlineLarge?.copyWith(color: cs.onSurface),
                ),
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.blur_on, color: cs.onSurface, size: 24),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.bar_chart, color: cs.onSurface, size: 24),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            SlidingToggle(
              options: const ['Personal', 'Group'],
              onSelectionChanged: (index) {},
            ),

            const SizedBox(height: 40),

            ValueListenableBuilder<ProjectSummary>(
              valueListenable: _summaryNotifier,
              builder: (context, summary, _) {
                return Column(
                  children: [
                    Center(
                      child: RepaintBoundary(
                        child: SegmentedDonutChart(
                          centerValue: '${summary.totalHours}h',
                          centerSubtitle: summary.dateRange,
                          segments: summary.projects,
                          animation: _allDrawAnimation,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    ValueListenableBuilder<String>(
                      valueListenable: _periodNotifier,
                      builder: (context, selectedPeriod, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: ['Day', 'Week', 'Month', 'Year'].map((
                            period,
                          ) {
                            final isActive = selectedPeriod == period;
                            return GestureDetector(
                              onTap: () => _onPeriodChanged(period),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Text(
                                  period,
                                  style: tt.bodyMedium?.copyWith(
                                    fontWeight: isActive
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isActive
                                        ? cs.onSurface
                                        : cs.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    ...summary.projects.map((project) {
                      return RepaintBoundary(
                        child: ProjectHorizontalBar(
                          label: project.name,
                          percentage: project.percentage,
                          valueText:
                              '${project.hours >= 100 ? project.hours.toInt() : project.hours}h',
                          color: project.color,
                          animation: _allDrawAnimation,
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
