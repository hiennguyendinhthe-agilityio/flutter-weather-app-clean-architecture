import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/utils/duration_formatter.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonGradientBackground(
        child: SafeArea(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              if (taskProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return _buildContent(context, taskProvider.allTasks);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Task> tasks) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UnconstrainedBox(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    'Track your productivity and project progress with detailed reports.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              _buildHeader(),
              _buildPeriodSelector(),
              _buildTimeChart(tasks),
              _buildProjectBreakdown(tasks),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        _buildRecentActivityList(tasks),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text(
            'Reports',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPeriodButton('Day'),
          _buildPeriodButton('Week'),
          _buildPeriodButton('Month'),
          _buildPeriodButton('Year'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = _selectedPeriod == period;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(period),
      ),
    );
  }

  Widget _buildTimeChart(List<Task> tasks) {
    final now = DateTime.now();
    final dayTotals = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayTasks = tasks.where((task) {
        return task.createdAt.isAfter(dayStart) &&
            task.createdAt.isBefore(dayEnd);
      }).toList();

      final totalMinutes = dayTasks.fold<int>(
        0,
        (sum, task) => sum + task.timeSpent.inMinutes,
      );

      return FlSpot(index.toDouble(), totalMinutes.toDouble());
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Time Spent',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${(value / 60).toInt()}h');
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final day =
                            now.subtract(Duration(days: 6 - value.toInt()));
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${day.day}/${day.month}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: dayTotals,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectBreakdown(List<Task> tasks) {
    final projectTotals = <String, Duration>{};

    for (final task in tasks) {
      final projectName = task.projectName;
      final currentTotal = projectTotals[projectName] ?? Duration.zero;
      projectTotals[projectName] = currentTotal + task.timeSpent;
    }

    final sortedProjects = projectTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...sortedProjects.take(3).map((entry) {
            final projectName = entry.key;
            final timeSpent = entry.value;
            final projectTasks =
                tasks.where((task) => task.projectName == projectName).toList();
            final projectColor = projectTasks.isNotEmpty
                ? projectTasks.first.projectColor
                : 'blue';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getColorFromName(projectColor),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        projectName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DurationFormatter.formatHoursMinutes(timeSpent),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: timeSpent.inMinutes / (timeSpent.inMinutes + 60),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _getColorFromName(projectColor)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList(List<Task> tasks) {
    final recentTasks = List<Task>.from(tasks)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final displayTasks = recentTasks.take(5).toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final task = displayTasks[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    _getColorFromName(task.projectColor).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  task.assignee.isNotEmpty ? task.assignee[0] : '',
                  style: TextStyle(
                    color: _getColorFromName(task.projectColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(task.projectName),
            trailing: Text(
              DurationFormatter.formatHoursMinutes(task.timeSpent),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        childCount: displayTasks.length,
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      case 'pink':
        return Colors.pink;
      case 'amber':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
