import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:uuid/uuid.dart';

class AddTaskBottomsheet extends StatefulWidget {
  final Function(Task) onAddTask;
  final Task? taskToEdit;
  const AddTaskBottomsheet(
      {super.key, required this.onAddTask, this.taskToEdit});

  @override
  State<AddTaskBottomsheet> createState() => _AddTaskBottomsheetState();
}

class _AddTaskBottomsheetState extends State<AddTaskBottomsheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _projectController;
  late TextEditingController _assigneeController;
  late List<String> _tags = [];
  late TextEditingController _tagController;

  String _selectedColor = 'blue';

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Blue', 'value': 'blue', 'color': Colors.blue},
    {'name': 'Green', 'value': 'green', 'color': Colors.green},
    {'name': 'Orange', 'value': 'orange', 'color': Colors.orange},
    {'name': 'Red', 'value': 'red', 'color': Colors.red},
    {'name': 'Purple', 'value': 'purple', 'color': Colors.purple},
    {'name': 'Teal', 'value': 'teal', 'color': Colors.teal},
  ];

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.taskToEdit?.title ?? '');
    _projectController =
        TextEditingController(text: widget.taskToEdit?.projectName ?? '');
    _assigneeController =
        TextEditingController(text: widget.taskToEdit?.assignee ?? '');
    _tagController = TextEditingController();
    _tags = List<String>.from(widget.taskToEdit?.tags ?? []);
    _selectedColor = widget.taskToEdit?.projectColor ?? 'blue';
    _startTime = widget.taskToEdit?.startTime;
    _endTime = widget.taskToEdit?.endTime;
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

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return 'Select time';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.taskToEdit != null;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isEditing ? 'Edit Task' : 'Add New Task',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
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
                      child: GestureDetector(
                        onTap: _selectStartTime,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Start Time'),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTimeOfDay(_startTime),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectEndTime,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('End Time'),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTimeOfDay(_endTime),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          prefixIcon: Icon(Icons.label),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addTag,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                if (_tags.isNotEmpty)
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _selectedColor == option['value']
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final String taskId = isEditing
                                ? widget.taskToEdit!.id
                                : const Uuid().v4();
                            final DateTime createdAt = isEditing
                                ? widget.taskToEdit!.createdAt
                                : DateTime.now();

                            final bool initialIsActive =
                                isEditing ? widget.taskToEdit!.isActive : false;
                            final bool initialIsCompleted = isEditing
                                ? widget.taskToEdit!.isCompleted
                                : false;
                            final bool initialIsArchived = isEditing
                                ? widget.taskToEdit!.isArchived
                                : false;
                            final Duration initialTimeSpent = isEditing
                                ? widget.taskToEdit!.timeSpent
                                : Duration.zero;

                            final taskData = Task(
                              id: taskId,
                              title: _titleController.text,
                              projectName: _projectController.text,
                              assignee: _assigneeController.text,
                              tags: _tags,
                              createdAt: createdAt,
                              startTime: _startTime,
                              endTime: _endTime,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(isEditing ? 'Save Changes' : 'Add Task'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
