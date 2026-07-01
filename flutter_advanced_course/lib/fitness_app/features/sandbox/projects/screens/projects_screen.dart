import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/charts/project_horizontal_bar.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/charts/segmented_donut_chart.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/common/sliding_toggle.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/projects/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _allDrawAnimation;

  @override
  void initState() {
    super.initState();

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
    _animationController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(String period) {
    final currentPeriod = ref.read(selectedProjectPeriodProvider);
    if (currentPeriod != period) {
      ref.read(selectedProjectPeriodProvider.notifier).setPeriod(period);
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
                      icon: Icon(
                        Icons.bar_chart,
                        color: cs.onSurface,
                        size: 24,
                      ),
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

            Builder(
              builder: (context) {
                final summary = ref.watch(projectSummaryProvider);
                final selectedPeriod = ref.watch(selectedProjectPeriodProvider);

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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ['Day', 'Week', 'Month', 'Year'].map((period) {
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
