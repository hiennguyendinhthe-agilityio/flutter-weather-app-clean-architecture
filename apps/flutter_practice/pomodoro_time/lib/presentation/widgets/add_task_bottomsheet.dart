// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/widgets/common_input_decoration.dart';
import 'package:task_management_app/presentation/widgets/date_time_field.dart';
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
  late TextEditingController _tagController;
  late TextEditingController _noteController;

  List<String> _tags = [];
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

  String? _selectedMusicTitle;
  String? _selectedMusicArtist;

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
    _noteController =
        TextEditingController(text: widget.taskToEdit?.note ?? '');
    _tags = List<String>.from(widget.taskToEdit?.tags ?? []);
    _selectedColor = widget.taskToEdit?.projectColor ?? 'blue';
    _startDateTime = widget.taskToEdit?.startTime;
    _endDateTime = widget.taskToEdit?.endTime;

    _selectedMusicTitle = widget.taskToEdit?.musicTitle;
    _selectedMusicArtist = widget.taskToEdit?.musicArtist;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _projectController.dispose();
    _assigneeController.dispose();
    _tagController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
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

  Future<void> _selectMusic() async {
    const pickedTitle = 'Begin Again';
    const pickedArtist = 'Taylor Swift';
    setState(() {
      _selectedMusicTitle = pickedTitle;
      _selectedMusicArtist = pickedArtist;
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: buildCommonDecoration(
                    context: context,
                    label: 'I’m focusing on',
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Please enter a task title'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectController,
                  decoration: buildCommonDecoration(
                    context: context,
                    label: 'Project',
                    hintText: 'Select project',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a project'
                      : null,
                  readOnly: true,
                  onTap: () {
                    // Open project selection dialog or dropdown
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Select Project'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                ListTile(
                                  title: const Text('Project A'),
                                  onTap: () {
                                    _projectController.text = 'Project A';
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text('Project B'),
                                  onTap: () {
                                    _projectController.text = 'Project B';
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _assigneeController,
                  decoration: buildCommonDecoration(
                    context: context,
                    label: 'Assignee',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter an assignee'
                      : null,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectMusic,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.music_note,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedMusicTitle != null
                                ? '$_selectedMusicTitle ($_selectedMusicArtist)'
                                : 'Add music (Optional)',
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedMusicTitle != null
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  decoration: buildCommonDecoration(
                    context: context,
                    label: 'Note',
                    hintText: 'Type here...',
                    isMultiline: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ..._tags.map((tag) => Chip(
                                  label: Text(tag),
                                  onDeleted: () => _removeTag(tag),
                                  backgroundColor: Colors.grey.shade200,
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                )),
                            SizedBox(
                              width: 80,
                              child: IntrinsicWidth(
                                child: TextField(
                                  controller: _tagController,
                                  decoration: const InputDecoration(
                                    hintText: 'Add tag',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DateTimeField(
                        dateTime: _startDateTime,
                        labelPrefix: 'Start',
                        onTap: _selectStartDateTime,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DateTimeField(
                        dateTime: _endDateTime,
                        labelPrefix: 'End',
                        onTap: _selectEndDateTime,
                      ),
                    ),
                  ],
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
                    final String val = option['value'];
                    final Color col = option['color'];
                    final bool isSelected = (_selectedColor == val);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = val;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: col,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side:
                              BorderSide(color: Colors.grey.shade400, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black87),
                        ),
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
                            note: _noteController.text,
                            musicTitle: _selectedMusicTitle,
                            musicArtist: _selectedMusicArtist,
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
                        child: Text(isEditing ? 'Save Changes' : 'Add Task'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
