import 'package:flutter/material.dart';
import 'widget_manager.dart';

class WidgetDashboard extends StatefulWidget {
  const WidgetDashboard({super.key});

  @override
  State<WidgetDashboard> createState() => _WidgetDashboardState();
}

class _WidgetDashboardState extends State<WidgetDashboard> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Foundation',
    'Layout',
    'Interactive',
    'Input',
    'Display',
    'Navigation',
    'Animation',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    WidgetManager.initializeLessons();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = selectedCategory == 'All'
        ? WidgetManager.getAllLessons()
        : WidgetManager.getLessonsByCategory(selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widget of the Week'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Text(
                  'Learning Progress',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: WidgetManager.getProgress(),
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(WidgetManager.getProgress() * 100).toInt()}% completed',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.blue.shade100,
                  ),
                );
              },
            ),
          ),

          // Lessons List
          Expanded(
            child: lessons.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.widgets, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No lessons available',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lessons will be added soon!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return _buildLessonCard(lesson);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(WidgetLesson lesson) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: lesson.isCompleted ? Colors.green : Colors.blue,
          child: lesson.isCompleted
              ? const Icon(Icons.check, color: Colors.white)
              : Text(
                  '${lesson.week}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lesson.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    lesson.difficulty,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getDifficultyColor(lesson.difficulty),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    lesson.category,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.grey.shade200,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => lesson.builder()),
          ).then((_) {
            // Mark as completed when returning
            setState(() {
              WidgetManager.markAsCompleted(lesson.id);
            });
          });
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Basic':
        return Colors.green.shade100;
      case 'Intermediate':
        return Colors.orange.shade100;
      case 'Advanced':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
