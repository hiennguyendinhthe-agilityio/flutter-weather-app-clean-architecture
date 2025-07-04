// 📁 add_task_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/data/models/task_form_view_model.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/cancel_save_button_row.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/date_time_picker_row.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/music_picker_dropdown.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/project_picker_dropdown.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/tag_input_field.dart';
import 'package:task_management_app/presentation/widgets/color_picker.dart';
import 'package:task_management_app/presentation/widgets/text_field.dart';
import 'package:uuid/uuid.dart';

class AddTaskBottomsheet extends StatefulWidget {
  final Function(Task) onAddTask;
  final Task? taskToEdit;
  final Function(Task)? onUpdateTask;
  final DateTime? selectedDate;

  const AddTaskBottomsheet({
    super.key,
    required this.onAddTask,
    this.taskToEdit,
    this.onUpdateTask,
    this.selectedDate,
  });

  @override
  State<AddTaskBottomsheet> createState() => _AddTaskBottomsheetState();
}

class _AddTaskBottomsheetState extends State<AddTaskBottomsheet> {
  final _formKey = GlobalKey<FormState>();
  late TaskFormViewModel _viewModel;
  final _titleFocusNode = FocusNode();
  final _assigneeFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();
  final _tagFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewModel = TaskFormViewModel(
      taskToEdit: widget.taskToEdit,
      initialDate: widget.selectedDate,
    );
  }

  @override
  void dispose() {
    _viewModel.disposeControllers();
    _titleFocusNode.dispose();
    _assigneeFocusNode.dispose();
    _noteFocusNode.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<TaskFormViewModel>(
        builder: (context, model, _) => Container(
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
            bottom: MediaQuery.of(context).viewInsets.bottom + 2,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              shrinkWrap: true,
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
                  focusNode: _titleFocusNode,
                  controller: model.titleController,
                  labelText: 'I’m focusing on',
                  hintText: 'Enter task title',
                  validator: (val) => val == null || val.isEmpty
                      ? 'Please enter a task title'
                      : null,
                ),
                const SizedBox(height: 16),
                ProjectPickerDropdown(
                  labelText: "Project",
                  initialValue: model.selectedProject,
                  onChanged: (project) => model.updateSelectedProject(project),
                ),
                const SizedBox(height: 16),
                PtTextField(
                  focusNode: _assigneeFocusNode,
                  controller: model.assigneeController,
                  labelText: 'Assignee',
                  hintText: 'Enter assignee',
                  validator: (val) => val == null || val.isEmpty
                      ? 'Please enter an assignee'
                      : null,
                ),
                const SizedBox(height: 16),
                MusicPickerDropdown(
                  labelText: 'Music (Optional)',
                  initialValue: model.selectedMusic,
                  onChanged: (music) => model.updateSelectedMusic(music),
                ),
                const SizedBox(height: 16),
                PtTextField(
                  focusNode: _noteFocusNode,
                  controller: model.noteController,
                  labelText: 'Note',
                  hintText: 'Type here...',
                  isMultiline: true,
                ),
                const SizedBox(height: 16),
                PtTagInputField(
                  focusNode: _tagFocusNode,
                  labelText: 'Tag',
                  tagController: model.tagController,
                  tags: model.tags,
                  onAdd: (tag) => model.addTag(tag),
                  onRemove: (tag) => model.removeTag(tag),
                ),
                const SizedBox(height: 16),
                DateTimePickerRow(
                  labelText: 'Start & End Time',
                  startDateTime: model.startDateTime,
                  endDateTime: model.endDateTime,
                  onPickDate: (dt) => model.updateDate(dt),
                  onPickStartTime: (dt) => model.updateStartTime(dt),
                  onPickEndTime: (dt) => model.updateEndTime(dt),
                ),
                const SizedBox(height: 16),
                ColorPicker(
                  selectedColor: model.selectedColor,
                  onColorSelected: (color) => model.updateSelectedColor(color),
                ),
                const SizedBox(height: 24),
                CancelSaveButtonRow(
                  isEditing: isEditing,
                  onCancel: () => Navigator.pop(context),
                  onSave: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final dateTimeError = model.validateDateTime();
                    if (dateTimeError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(dateTimeError),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final task = model.toTask(
                      id: const Uuid().v4(),
                      createdAt: DateTime.now(),
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
      ),
    );
  }
}
