import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/project.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/music_picker_dropdown.dart';

class TaskFormViewModel extends ChangeNotifier {
  final Task? taskToEdit;

  final titleController = TextEditingController();
  final assigneeController = TextEditingController();
  final noteController = TextEditingController();
  final tagController = TextEditingController();

  List<String> tags = [];
  String selectedColor = 'blue';
  DateTime? startDateTime;
  DateTime? endDateTime;
  MusicModel? selectedMusic;
  ProjectModel? selectedProject;

  TaskFormViewModel({this.taskToEdit, DateTime? initialDate}) {
    if (taskToEdit != null) {
      titleController.text = taskToEdit!.title;
      assigneeController.text = taskToEdit!.assignee;
      noteController.text = taskToEdit!.note ?? '';
      tags = List<String>.from(taskToEdit!.tags);
      selectedColor = taskToEdit!.projectColor;
      startDateTime = taskToEdit!.startTime;
      endDateTime = taskToEdit!.endTime;

      final musicTitle = taskToEdit!.musicTitle;
      final musicArtist = taskToEdit!.musicArtist;
      if (musicTitle != null && musicArtist != null) {
        selectedMusic = MusicModel(title: musicTitle, artist: musicArtist);
      }

      final projectName = taskToEdit!.projectName;

      if (projectName.isNotEmpty) {
        selectedProject = ProjectModel(
          projectName: projectName,
          clientName: '',
          clientRole: '',
          avatarUrl: '',
        );
      }
    } else if (initialDate != null) {
      startDateTime =
          DateTime(initialDate.year, initialDate.month, initialDate.day, 9);
      endDateTime =
          DateTime(initialDate.year, initialDate.month, initialDate.day, 10);
    }
  }

  void disposeControllers() {
    titleController.dispose();
    assigneeController.dispose();
    noteController.dispose();
    tagController.dispose();
  }

  void updateSelectedProject(ProjectModel? project) {
    selectedProject = project;
    notifyListeners();
  }

  void updateSelectedMusic(MusicModel? music) {
    selectedMusic = music;
    notifyListeners();
  }

  void addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
      tagController.clear();
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
    notifyListeners();
  }

  void updateSelectedColor(String color) {
    selectedColor = color;
    notifyListeners();
  }

  void updateDate(DateTime newDate) {
    if (startDateTime == null) {
      startDateTime = DateTime(newDate.year, newDate.month, newDate.day, 9, 0);
      endDateTime = DateTime(newDate.year, newDate.month, newDate.day, 10, 0);
    } else {
      final oldStart = startDateTime!;
      final oldEnd = endDateTime ?? oldStart.add(const Duration(hours: 1));
      final duration = oldEnd.difference(oldStart);

      startDateTime = DateTime(newDate.year, newDate.month, newDate.day,
          oldStart.hour, oldStart.minute);
      endDateTime = startDateTime!.add(duration);
    }
    notifyListeners();
  }

  void updateStartTime(DateTime newStartTime) {
    startDateTime = newStartTime;
    if (endDateTime != null && endDateTime!.isBefore(startDateTime!)) {
      endDateTime = startDateTime!.add(const Duration(hours: 1));
    }
    notifyListeners();
  }

  void updateEndTime(DateTime newEndTime) {
    endDateTime = newEndTime;
    notifyListeners();
  }

  Task toTask({required String id, required DateTime createdAt}) {
    if (startDateTime == null || endDateTime == null) {
      throw Exception('Start or End time is null');
    }

    return Task(
      id: taskToEdit?.id ?? id,
      title: titleController.text,
      projectName: selectedProject?.projectName ?? '',
      assignee: assigneeController.text,
      tags: tags,
      note: noteController.text,
      musicTitle: selectedMusic?.title,
      musicArtist: selectedMusic?.artist,
      createdAt: taskToEdit?.createdAt ?? createdAt,
      startTime: startDateTime!,
      endTime: endDateTime!,
      timeSpent: taskToEdit?.timeSpent ?? Duration.zero,
      isActive: taskToEdit?.isActive ?? false,
      isCompleted: taskToEdit?.isCompleted ?? false,
      projectColor: selectedColor,
      isArchived: taskToEdit?.isArchived ?? false,
    );
  }

  String? validateDateTime() {
    if (startDateTime == null || endDateTime == null) {
      return 'Please select start and end date/time';
    }
    if (endDateTime!.isBefore(startDateTime!)) {
      return 'End time cannot be before start time';
    }
    return null;
  }
}
