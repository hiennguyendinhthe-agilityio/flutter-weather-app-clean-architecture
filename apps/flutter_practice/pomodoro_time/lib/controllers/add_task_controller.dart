// Logic-only controller for AddTaskBottomsheet

import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:uuid/uuid.dart';

class AddTaskController {
  final Task? taskToEdit;

  late TextEditingController titleController;
  late TextEditingController projectController;
  late TextEditingController assigneeController;
  late TextEditingController tagController;
  late TextEditingController noteController;

  List<String> tags = [];
  String selectedColor = 'blue';
  DateTime? startDateTime;
  DateTime? endDateTime;

  String? selectedMusicTitle;
  String? selectedMusicArtist;

  AddTaskController({this.taskToEdit}) {
    titleController = TextEditingController(text: taskToEdit?.title ?? '');
    projectController =
        TextEditingController(text: taskToEdit?.projectName ?? '');
    assigneeController =
        TextEditingController(text: taskToEdit?.assignee ?? '');
    tagController = TextEditingController();
    noteController = TextEditingController(text: taskToEdit?.note ?? '');

    tags = List<String>.from(taskToEdit?.tags ?? []);
    selectedColor = taskToEdit?.projectColor ?? 'blue';
    startDateTime = taskToEdit?.startTime;
    endDateTime = taskToEdit?.endTime;

    selectedMusicTitle = taskToEdit?.musicTitle;
    selectedMusicArtist = taskToEdit?.musicArtist;
  }

  void dispose() {
    titleController.dispose();
    projectController.dispose();
    assigneeController.dispose();
    tagController.dispose();
    noteController.dispose();
  }

  Task buildTask() {
    return Task(
      id: taskToEdit?.id ?? const Uuid().v4(),
      title: titleController.text,
      projectName: projectController.text,
      assignee: assigneeController.text,
      tags: tags,
      note: noteController.text,
      musicTitle: selectedMusicTitle,
      musicArtist: selectedMusicArtist,
      createdAt: taskToEdit?.createdAt ?? DateTime.now(),
      startTime: startDateTime!,
      endTime: endDateTime!,
      timeSpent: taskToEdit?.timeSpent ?? Duration.zero,
      isActive: taskToEdit?.isActive ?? false,
      isCompleted: taskToEdit?.isCompleted ?? false,
      projectColor: selectedColor,
      isArchived: taskToEdit?.isArchived ?? false,
    );
  }

  bool validateDateTimes(BuildContext context) {
    if (startDateTime == null || endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end date/time'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (endDateTime!.isBefore(startDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time cannot be before start time'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }
}
