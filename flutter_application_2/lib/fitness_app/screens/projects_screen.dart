import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/project_data.dart';
import '../repositories/project_repository.dart';
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
  String _selectedPeriod = 'Week';
  late ProjectSummary _currentSummary;
  late AnimationController _animationController;
  late Animation<double> _allDrawAnimation;

  @override
  void initState() {
    super.initState();
    _currentSummary = ProjectRepository.getSummary(_selectedPeriod);

    _animationController = AnimationController(
      duration: const Duration(seconds: 2), // Slowed down as requested
      vsync: this,
    );

    _allDrawAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic, // Smoother finish, less stutter
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitnessColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _allDrawAnimation,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Projects',
                      style: FitnessTextStyles.projectHeader,
                    ),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.blur_on,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.bar_chart,
                            color: Colors.white,
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
                Center(
                  child: SegmentedDonutChart(
                    centerValue: '${_currentSummary.totalHours}h',
                    centerSubtitle: _currentSummary.dateRange,
                    segments: _currentSummary.projects,
                    progress: _allDrawAnimation.value,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['Day', 'Week', 'Month', 'Year'].map((period) {
                    final isActive = _selectedPeriod == period;
                    return GestureDetector(
                      onTap: () {
                        if (_selectedPeriod != period) {
                          setState(() {
                            _selectedPeriod = period;
                            _currentSummary = ProjectRepository.getSummary(
                              period,
                            );
                          });
                          _animationController.forward(
                            from: 0,
                          ); // Restart animation
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          period,
                          style: isActive
                              ? FitnessTextStyles.filterTabActive
                              : FitnessTextStyles.filterTabInactive,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                ..._currentSummary.projects.map((project) {
                  return ProjectHorizontalBar(
                    label: project.name,
                    percentage: project.percentage,
                    valueText:
                        '${project.hours >= 100 ? project.hours.toInt() : project.hours}h',
                    color: project.color,
                    progress: _allDrawAnimation.value,
                  );
                }),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
