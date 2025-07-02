import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/project.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/music_picker_dropdown.dart';
import 'package:uuid/uuid.dart';

class TaskFormViewModel extends ChangeNotifier {
  final Task? taskToEdit;

  // Controllers
  final titleController = TextEditingController();
  final assigneeController = TextEditingController();
  final noteController = TextEditingController();
  final tagController = TextEditingController();

  // State
  List<String> tags = [];
  String selectedColor = 'blue';
  DateTime? startDateTime;
  DateTime? endDateTime;
  MusicModel? selectedMusic;
  ProjectModel? selectedProject;

  TaskFormViewModel({this.taskToEdit}) {
    if (taskToEdit != null) {
      titleController.text = taskToEdit!.title;
      assigneeController.text = taskToEdit!.assignee;
      noteController.text = taskToEdit!.note!;
      tags = List<String>.from(taskToEdit!.tags);
      selectedColor = taskToEdit!.projectColor;
      startDateTime = taskToEdit!.startTime;
      endDateTime = taskToEdit!.endTime;

      if (taskToEdit!.musicTitle != null && taskToEdit!.musicArtist != null) {
        selectedMusic = MusicModel(
          title: taskToEdit!.musicTitle!,
          artist: taskToEdit!.musicArtist!,
        );
      }

      if (taskToEdit!.projectName.isNotEmpty) {
        selectedProject = ProjectModel(
          projectName: taskToEdit!.projectName,
          clientName: 'Roberto',
          clientRole: 'Client',
          avatarUrl: 'https://i.pravatar.cc/150?img=3',
        );
      }
    }
  }

  void updateStartDateTime(DateTime dt) {
    startDateTime = dt;
    notifyListeners();
  }

  void updateEndDateTime(DateTime dt) {
    endDateTime = dt;
    notifyListeners();
  }

  void addTag(String tag) {
    tags.add(tag);
    notifyListeners();
  }

  void removeTag(String tag) {
    tags.remove(tag);
    notifyListeners();
  }

  void selectColor(String color) {
    selectedColor = color;
    notifyListeners();
  }

  void selectMusic(MusicModel? music) {
    selectedMusic = music;
    notifyListeners();
  }

  void selectProject(ProjectModel? project) {
    selectedProject = project;
    notifyListeners();
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  String? get timeValidationError {
    if (startDateTime == null || endDateTime == null) {
      return 'Please select start and end date/time';
    }
    if (endDateTime!.isBefore(startDateTime!)) {
      return 'End time cannot be before start time';
    }
    return null;
  }

  Task buildTask() {
    return Task(
      id: taskToEdit?.id ?? const Uuid().v4(),
      title: titleController.text,
      projectName: selectedProject?.projectName ?? '',
      assignee: assigneeController.text,
      tags: tags,
      note: noteController.text,
      musicTitle: selectedMusic?.title,
      musicArtist: selectedMusic?.artist,
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

  void disposeControllers() {
    titleController.dispose();
    assigneeController.dispose();
    tagController.dispose();
    noteController.dispose();
  }
}
