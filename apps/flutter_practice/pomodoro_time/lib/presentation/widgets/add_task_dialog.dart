import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:uuid/uuid.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAddTask;
  final Task? taskToEdit;

  const AddTaskDialog({
    super.key,
    required this.onAddTask,
    this.taskToEdit,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _projectController = TextEditingController();
  late TextEditingController _assigneeController = TextEditingController();

  late List<String> _tags = [];
  late TextEditingController _tagController = TextEditingController();
  String _selectedColor = 'blue';

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Blue', 'value': 'blue', 'color': Colors.blue},
    {'name': 'Green', 'value': 'green', 'color': Colors.green},
    {'name': 'Orange', 'value': 'orange', 'color': Colors.orange},
    {'name': 'Red', 'value': 'red', 'color': Colors.red},
    {'name': 'Purple', 'value': 'purple', 'color': Colors.purple},
    {'name': 'Teal', 'value': 'teal', 'color': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.taskToEdit?.title ?? '');
    _projectController =
        TextEditingController(text: widget.taskToEdit?.projectName ?? '');
    _assigneeController =
        TextEditingController(text: widget.taskToEdit?.assignee ?? '');
    _tags = List<String>.from(widget.taskToEdit?.tags ?? []);
    _tagController = TextEditingController();
    _selectedColor = widget.taskToEdit?.projectColor ?? 'blue';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _projectController.dispose();
    _assigneeController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty &&
        !_tags.contains(_tagController.text)) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.taskToEdit != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'Add New Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _projectController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _assigneeController,
                decoration: const InputDecoration(
                  labelText: 'Assignee',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an assignee';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        labelText: 'Add Tag',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTag,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeTag(tag),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Project Color:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _colorOptions.map((option) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = option['value'];
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: option['color'],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == option['value']
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final String taskId =
                  isEditing ? widget.taskToEdit!.id : const Uuid().v4();
              final DateTime createdAt =
                  isEditing ? widget.taskToEdit!.createdAt : DateTime.now();

              final bool initialIsActive =
                  isEditing ? widget.taskToEdit!.isActive : false;
              final bool initialIsCompleted =
                  isEditing ? widget.taskToEdit!.isCompleted : false;
              final bool initialIsArchived =
                  isEditing ? widget.taskToEdit!.isArchived : false;
              final Duration initialTimeSpent =
                  isEditing ? widget.taskToEdit!.timeSpent : Duration.zero;

              final taskData = Task(
                id: taskId,
                title: _titleController.text,
                projectName: _projectController.text,
                assignee: _assigneeController.text,
                tags: _tags,
                createdAt: createdAt,
                timeSpent: initialTimeSpent,
                isActive: initialIsActive,
                isCompleted: initialIsCompleted,
                projectColor: _selectedColor,
                isArchived: initialIsArchived,
              );

              widget.onAddTask(taskData);
              Navigator.of(context).pop();
            }
          },
          child: Text(isEditing ? 'Save Changes' : 'Add Task'),
        ),
      ],
    );
  }
}
