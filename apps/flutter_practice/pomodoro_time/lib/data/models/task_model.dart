// lib/data/models/task_model.dart
import 'package:task_management_app/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String title,
    required String projectName,
    required String assignee,
    required List<String> tags,
    required DateTime createdAt,
    required Duration timeSpent,
    required bool isActive,
    required bool isCompleted,
    required String projectColor,
  }) : super(
          id: id,
          title: title,
          projectName: projectName,
          assignee: assignee,
          tags: tags,
          createdAt: createdAt,
          timeSpent: timeSpent,
          isActive: isActive,
          isCompleted: isCompleted,
          projectColor: projectColor,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      projectName: json['projectName'],
      assignee: json['assignee'],
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.parse(json['createdAt']),
      timeSpent: Duration(milliseconds: json['timeSpent']),
      isActive: json['isActive'],
      isCompleted: json['isCompleted'],
      projectColor: json['projectColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'projectName': projectName,
      'assignee': assignee,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'timeSpent': timeSpent.inMilliseconds,
      'isActive': isActive,
      'isCompleted': isCompleted,
      'projectColor': projectColor,
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      projectName: task.projectName,
      assignee: task.assignee,
      tags: task.tags,
      createdAt: task.createdAt,
      timeSpent: task.timeSpent,
      isActive: task.isActive,
      isCompleted: task.isCompleted,
      projectColor: task.projectColor,
    );
  }
}
