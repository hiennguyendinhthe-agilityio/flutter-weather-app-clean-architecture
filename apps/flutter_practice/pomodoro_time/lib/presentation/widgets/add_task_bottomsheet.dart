import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:uuid/uuid.dart';

class AddTaskBottomsheet extends StatefulWidget {
  final Function(Task) onAddTask;
  final Task? taskToEdit;
  final Function(Task)? onUpdateTask;

  const AddTaskBottomsheet({
    super.key,
    required this.onAddTask,
    this.taskToEdit,
    this.onUpdateTask,
  });

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

  DateTime? _startDateTime;
  DateTime? _endDateTime;

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
    _startDateTime = widget.taskToEdit?.startTime;
    _endDateTime = widget.taskToEdit?.endTime;
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

  Future<void> _selectStartDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _startDateTime ?? now;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    final TimeOfDay initialTime = TimeOfDay.fromDateTime(_startDateTime ?? now);

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime == null) return;

    setState(() {
      _startDateTime = DateTime(pickedDate.year, pickedDate.month,
          pickedDate.day, pickedTime.hour, pickedTime.minute);
    });
  }

  Future<void> _selectEndDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _endDateTime ?? _startDateTime ?? now;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _startDateTime ?? now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    final TimeOfDay initialTime =
        TimeOfDay.fromDateTime(_endDateTime ?? _startDateTime ?? now);

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime == null) return;

    setState(() {
      _endDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
          pickedTime.hour, pickedTime.minute);
    });
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Select date & time';
    return '${DateFormat('yyyy-MM-dd').format(dt)}\n${DateFormat('HH:mm').format(dt)}';
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a task title'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a project name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _assigneeController,
                  decoration: const InputDecoration(
                    labelText: 'Assignee',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter an assignee'
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectStartDateTime,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Start: ${_formatDateTime(_startDateTime)}',
                                  maxLines: 2,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectEndDateTime,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'End: ${_formatDateTime(_endDateTime)}',
                                  maxLines: 2,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
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
                          if (!_formKey.currentState!.validate()) return;

                          if (_startDateTime == null || _endDateTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please select start and end date/time'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (_endDateTime!.isBefore(_startDateTime!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'End time cannot be before start time'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final String taskId =
                              widget.taskToEdit?.id ?? const Uuid().v4();
                          final DateTime createdAt =
                              widget.taskToEdit?.createdAt ?? DateTime.now();
                          final bool initialIsActive =
                              widget.taskToEdit?.isActive ?? false;
                          final bool initialIsCompleted =
                              widget.taskToEdit?.isCompleted ?? false;
                          final bool initialIsArchived =
                              widget.taskToEdit?.isArchived ?? false;
                          final Duration initialTimeSpent =
                              widget.taskToEdit?.timeSpent ?? Duration.zero;

                          final taskData = Task(
                            id: taskId,
                            title: _titleController.text,
                            projectName: _projectController.text,
                            assignee: _assigneeController.text,
                            tags: _tags,
                            createdAt: createdAt,
                            startTime: _startDateTime!,
                            endTime: _endDateTime!,
                            timeSpent: initialTimeSpent,
                            isActive: initialIsActive,
                            isCompleted: initialIsCompleted,
                            projectColor: _selectedColor,
                            isArchived: initialIsArchived,
                          );

                          if (widget.taskToEdit != null &&
                              widget.onUpdateTask != null) {
                            widget.onUpdateTask!(taskData);
                          } else {
                            widget.onAddTask(taskData);
                          }

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(widget.taskToEdit != null
                            ? 'Save Changes'
                            : 'Add Task'),
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
