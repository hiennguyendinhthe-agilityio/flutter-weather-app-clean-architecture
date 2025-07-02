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

class AddTaskBottomsheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskFormViewModel(taskToEdit: taskToEdit),
      child: _AddTaskForm(
        isEditing: taskToEdit != null,
        onAddTask: onAddTask,
        onUpdateTask: onUpdateTask,
      ),
    );
  }
}

class _AddTaskForm extends StatefulWidget {
  final bool isEditing;
  final Function(Task) onAddTask;
  final Function(Task)? onUpdateTask;

  const _AddTaskForm({
    required this.isEditing,
    required this.onAddTask,
    this.onUpdateTask,
  });

  @override
  State<_AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<_AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode _titleFocusNode;
  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskFormViewModel>();
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
                widget.isEditing ? 'Edit Task' : 'Add New Task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              PtTextField(
                focusNode: _titleFocusNode,
                controller: viewModel.titleController,
                labelText: 'I’m focusing on',
                hintText: 'Enter task title',
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter a task title'
                    : null,
              ),
              const SizedBox(height: 16),
              ProjectPickerDropdown(
                labelText: "Project",
                initialValue: viewModel.selectedProject,
                onChanged: viewModel.selectProject,
              ),
              const SizedBox(height: 16),
              PtTextField(
                controller: viewModel.assigneeController,
                labelText: 'Assignee',
                hintText: 'Enter assignee',
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter an assignee'
                    : null,
              ),
              const SizedBox(height: 16),
              MusicPickerDropdown(
                labelText: 'Music (Optional)',
                initialValue: viewModel.selectedMusic,
                onChanged: viewModel.selectMusic,
              ),
              const SizedBox(height: 16),
              PtTextField(
                controller: viewModel.noteController,
                labelText: 'Note',
                hintText: 'Type here...',
                isMultiline: true,
              ),
              const SizedBox(height: 16),
              PtTagInputField(
                labelText: 'Tag',
                tagController: viewModel.tagController,
                tags: viewModel.tags,
                onAdd: viewModel.addTag,
                onRemove: viewModel.removeTag,
              ),
              const SizedBox(height: 16),
              DateTimePickerRow(
                labelText: 'Start & End Time',
                startDateTime: viewModel.startDateTime,
                endDateTime: viewModel.endDateTime,
                onPickDate: viewModel.updateStartDateTime,
                onPickStartTime: viewModel.updateStartDateTime,
                onPickEndTime: viewModel.updateEndDateTime,
              ),
              const SizedBox(height: 16),
              ColorPicker(
                selectedColor: viewModel.selectedColor,
                onColorSelected: viewModel.selectColor,
              ),
              const SizedBox(height: 24),
              CancelSaveButtonRow(
                isEditing: widget.isEditing,
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  if (!viewModel.validateForm(_formKey)) return;

                  final error = viewModel.timeValidationError;
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(error), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  final task = viewModel.buildTask();
                  if (widget.isEditing && widget.onUpdateTask != null) {
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
