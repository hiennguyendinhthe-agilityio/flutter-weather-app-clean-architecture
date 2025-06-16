import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';

/// Dialog for viewing and editing task details
class TaskDetailDialog extends StatefulWidget {
  final Task? task;

  const TaskDetailDialog({
    super.key,
    this.task,
  });

  @override
  State<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends State<TaskDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uuid = const Uuid();

  late DateTime _startTime;
  late DateTime _endTime;
  late TaskStatus _status;
  late TaskPriority _priority;
  String? _selectedTeamId;
  String _selectedProjectId = 'project_1';
  List<String> _tags = [];

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (_isEditing) {
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _startTime = task.startTime;
      _endTime = task.endTime;
      _status = task.status;
      _priority = task.priority;
      _selectedTeamId = task.teamId;
      _selectedProjectId = task.projectId;
      _tags = List.from(task.tags);
    } else {
      final now = DateTime.now();
      final selectedDate =
          Provider.of<TaskProvider>(context, listen: false).selectedDate;
      _startTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        now.hour,
        0,
      );
      _endTime = _startTime.add(const Duration(hours: 1));
      _status = TaskStatus.todo;
      _priority = TaskPriority.medium;
      _selectedTeamId =
          Provider.of<TaskProvider>(context, listen: false).selectedTeamId;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildBasicFields(),
              const SizedBox(height: 16),
              _buildTimeFields(),
              const SizedBox(height: 16),
              _buildStatusAndPriority(),
              const SizedBox(height: 16),
              _buildTeamAndProject(),
              const SizedBox(height: 24),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          _isEditing ? Icons.edit : Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          _isEditing ? 'Edit Task' : 'Add Task',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildBasicFields() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTimeFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTimeField(
            label: 'Start Time',
            time: _startTime,
            onChanged: (time) => setState(() => _startTime = time),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTimeField(
            label: 'End Time',
            time: _endTime,
            onChanged: (time) => setState(() => _endTime = time),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required DateTime time,
    required Function(DateTime) onChanged,
  }) {
    return InkWell(
      onTap: () => _selectTime(time, onChanged),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          style: GoogleFonts.roboto(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildStatusAndPriority() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<TaskStatus>(
            value: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: TaskStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    Icon(status.icon, size: 16, color: status.color),
                    const SizedBox(width: 8),
                    Text(status.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _status = value!),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<TaskPriority>(
            value: _priority,
            decoration: const InputDecoration(
              labelText: 'Priority',
              border: OutlineInputBorder(),
            ),
            items: TaskPriority.values.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: priority.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(priority.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _priority = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamAndProject() {
    return Consumer2<AuthProvider, TaskProvider>(
      builder: (context, authProvider, taskProvider, child) {
        return Column(
          children: [
            DropdownButtonFormField<String?>(
              value: _selectedTeamId,
              decoration: const InputDecoration(
                labelText: 'Team',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Personal'),
                ),
                ...authProvider.teams.map((team) {
                  return DropdownMenuItem<String?>(
                    value: team.id,
                    child: Text(team.name),
                  );
                }),
              ],
              onChanged: (value) => setState(() => _selectedTeamId = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedProjectId,
              decoration: const InputDecoration(
                labelText: 'Project',
                border: OutlineInputBorder(),
              ),
              items: taskProvider.projects.map((project) {
                return DropdownMenuItem<String>(
                  value: project.id,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: project.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(project.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedProjectId = value!),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        if (_isEditing) ...[
          TextButton.icon(
            onPressed: _deleteTask,
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          const Spacer(),
        ] else
          const Spacer(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _saveTask,
          child: Text(_isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _selectTime(
      DateTime currentTime, Function(DateTime) onChanged) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentTime),
    );

    if (time != null) {
      final newTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        time.hour,
        time.minute,
      );
      onChanged(newTime);
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    if (_endTime.isBefore(_startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final task = Task(
      id: _isEditing ? widget.task!.id : _uuid.v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _startTime,
      endTime: _endTime,
      status: _status,
      priority: _priority,
      assigneeId: authProvider.currentUser?.id ?? 'user_1',
      teamId: _selectedTeamId,
      projectId: _selectedProjectId,
      tags: _tags,
      createdAt: _isEditing ? widget.task!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      taskProvider.updateTask(task);
    } else {
      taskProvider.addTask(task);
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Task updated' : 'Task created'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteTask() {
    if (!_isEditing) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation dialog
              Navigator.of(context).pop(); // Close task detail dialog

              final taskProvider =
                  Provider.of<TaskProvider>(context, listen: false);
              taskProvider.deleteTask(widget.task!.id);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
