import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/widgets/cancel_save_button_row.dart';
import 'package:task_management_app/presentation/widgets/color_picker.dart';
import 'package:task_management_app/presentation/widgets/date_time_picker_row.dart';
import 'package:task_management_app/presentation/widgets/music_picker_tile.dart';
import 'package:task_management_app/presentation/widgets/tag_input_field.dart';
import 'package:task_management_app/presentation/widgets/text_field.dart';
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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
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
              PtTextField(
                controller: _titleController,
                labelText: 'I’m focusing on',
                hintText: 'Enter task title',
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter a task title'
                    : null,
              ),
              const SizedBox(height: 16),
              PtTextField(
                controller: _assigneeController,
                labelText: 'Assignee',
                hintText: 'Enter assignee',
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter an assignee'
                    : null,
              ),
              const SizedBox(height: 16),
              MusicPickerTile(
                labelText: 'Music (Optional)',
                selectedTitle: _selectedMusicTitle,
                selectedArtist: _selectedMusicArtist,
                onPickMusic: () {
                  setState(() {
                    _selectedMusicTitle = 'Begin Again';
                    _selectedMusicArtist = 'Taylor Swift';
                  });
                },
              ),
              const SizedBox(height: 16),
              PtTextField(
                controller: _noteController,
                labelText: 'Note',
                hintText: 'Type here...',
                isMultiline: true,
              ),
              const SizedBox(height: 16),
              PtTagInputField(
                labelText: 'Tag',
                tagController: _tagController,
                tags: _tags,
                onAdd: (tag) => setState(() => _tags.add(tag)),
                onRemove: (tag) => setState(() => _tags.remove(tag)),
              ),
              const SizedBox(height: 16),
              DateTimePickerRow(
                labelText: 'Start & End Time',
                startDateTime: _startDateTime,
                endDateTime: _endDateTime,
                onPickDate: (dt) => setState(() => _startDateTime = dt),
                onPickStartTime: (dt) => setState(() => _startDateTime = dt),
                onPickEndTime: (dt) => setState(() => _endDateTime = dt),
              ),
              const SizedBox(height: 16),
              ColorPicker(
                selectedColor: _selectedColor,
                onColorSelected: (color) =>
                    setState(() => _selectedColor = color),
              ),
              const SizedBox(height: 24),
              CancelSaveButtonRow(
                isEditing: isEditing,
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  if (!_formKey.currentState!.validate()) return;

                  if (_startDateTime == null || _endDateTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select start and end date/time'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (_endDateTime!.isBefore(_startDateTime!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('End time cannot be before start time'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final task = Task(
                    id: widget.taskToEdit?.id ?? const Uuid().v4(),
                    title: _titleController.text,
                    projectName: _projectController.text,
                    assignee: _assigneeController.text,
                    tags: _tags,
                    note: _noteController.text,
                    musicTitle: _selectedMusicTitle,
                    musicArtist: _selectedMusicArtist,
                    createdAt: widget.taskToEdit?.createdAt ?? DateTime.now(),
                    startTime: _startDateTime!,
                    endTime: _endDateTime!,
                    timeSpent: widget.taskToEdit?.timeSpent ?? Duration.zero,
                    isActive: widget.taskToEdit?.isActive ?? false,
                    isCompleted: widget.taskToEdit?.isCompleted ?? false,
                    projectColor: _selectedColor,
                    isArchived: widget.taskToEdit?.isArchived ?? false,
                  );

                  if (isEditing && widget.onUpdateTask != null) {
                    widget.onUpdateTask!(task);
                  } else {
                    widget.onAddTask(task);
                  }

                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
