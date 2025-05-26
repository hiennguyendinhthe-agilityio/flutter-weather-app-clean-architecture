import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';
import 'package:task_management_app/presentation/widgets/add_task_bottomsheet.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late DateTime _selectedDate;
  late ScrollController _scrollController;
  bool _hasScrolledToSelectedDate = false;

  static const double hourHeight = 60;
  static const int startHour = 0;
  late ScrollController _timelineScrollController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _scrollController = ScrollController();
    _timelineScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasScrolledToSelectedDate && _scrollController.hasClients) {
        _jumpToToday();
        _scrollToCurrentTime();
        _hasScrolledToSelectedDate = true;
      }
    });
  }

  void _scrollToCurrentTime() {
    final now = TimeOfDay.now();
    final minutesFromStart = (now.hour - startHour) * 60 + now.minute;
    final offset = minutesFromStart * (hourHeight / 60) - 100;
    if (_timelineScrollController.hasClients) {
      _timelineScrollController.jumpTo(offset.clamp(
          0.0, _timelineScrollController.position.maxScrollExtent));
    }
  }

  void _jumpToToday() {
    const itemWidth = 60.0 + 8.0;
    const todayIndex = 30;

    final offset = todayIndex * itemWidth -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);

    _scrollController
        .jumpTo(offset.clamp(0.0, _scrollController.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timelineScrollController.dispose();
    super.dispose();
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddTaskBottomsheet(onAddTask: (task) {
              Provider.of<TaskProvider>(context, listen: false).addTask(task);
            }));
  }

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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildDateSelector(),
                    Expanded(
                      child: _buildTimelineView(taskProvider.allTasks),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const Text(
            'Calendar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _showAddTaskBottomSheet,
            icon: const Text(
              'New Task',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            label: const Icon(Icons.add, color: Colors.black, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final now = DateTime.now();
    const totalDays = 61;
    final days = List.generate(
      totalDays,
      (index) => now.subtract(Duration(days: 30 - index)),
    );

    const dayItemWidth = 60.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Today, ${DateFormat('MMMM d').format(_selectedDate)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                _scrollController.jumpTo(
                  _scrollController.offset - details.delta.dx,
                );
              },
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isSelected = day.year == _selectedDate.year &&
                      day.month == _selectedDate.month &&
                      day.day == _selectedDate.day;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = day;
                      });
                      if (_timelineScrollController.hasClients) {
                        if (day == DateTime.now()) {
                          _scrollToCurrentTime();
                        } else {
                          _timelineScrollController.jumpTo(0);
                        }
                      }
                    },
                    child: Container(
                      width: dayItemWidth,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E').format(day)[0],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            day.day.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineView(List<Task> tasks) {
    final filteredTasks = tasks.where((task) {
      final taskDate = DateTime(
        task.startTime.year,
        task.startTime.month,
        task.startTime.day,
      );
      final selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      return taskDate.isAtSameMomentAs(selectedDate);
    }).toList();

    const totalHours = 24;
    const timelineHeight = totalHours * hourHeight;

    return SingleChildScrollView(
      controller: ScrollController(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        height: timelineHeight,
        child: Stack(
          children: [
            ...List.generate(totalHours + 1, (index) {
              final hour = index;
              return Positioned(
                top: index * hourHeight - 8,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}:00',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                  ],
                ),
              );
            }),
            ...filteredTasks.map((task) {
              final startMinutes =
                  task.startTime.hour * 60 + task.startTime.minute;
              final endMinutes = task.endTime.hour * 60 + task.endTime.minute;
              final top = startMinutes * (hourHeight / 60);
              final height = (endMinutes - startMinutes) * (hourHeight / 60);

              return Positioned(
                top: top,
                left: 68,
                right: 0,
                height: height.clamp(40, double.infinity),
                child: _buildTaskCard(task),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _getColorFromName(task.projectColor),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    task.assignee.isNotEmpty
                        ? task.assignee[0].toUpperCase()
                        : '',
                    style: TextStyle(
                      color: _getColorFromName(task.projectColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getColorFromName(task.projectColor),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${task.projectName} (${task.assignee})',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        Positioned(
          bottom: 8,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFDFE3E8),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDuration(task.timeSpent),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${(task.timeSpent.inMinutes * 0.5).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      default:
        return Colors.grey;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
