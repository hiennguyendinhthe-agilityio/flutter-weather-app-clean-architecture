class Task {
  final String id;
  final String title;
  final String projectName;
  final String assignee;
  final List<String> tags;
  final DateTime createdAt;
  final Duration timeSpent;
  final bool isActive;
  final bool isCompleted;
  final String projectColor;
  final bool isArchived;
  final DateTime startTime;
  final DateTime endTime;

  Task({
    required this.id,
    required this.title,
    required this.projectName,
    required this.assignee,
    required this.tags,
    required this.createdAt,
    required this.timeSpent,
    required this.isActive,
    this.isCompleted = false,
    required this.projectColor,
    this.isArchived = false,
    required this.startTime,
    required this.endTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
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
      isArchived: json['isArchived'] ?? false,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : DateTime.now(),
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
      'isArchived': isArchived,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? projectName,
    String? assignee,
    List<String>? tags,
    DateTime? createdAt,
    Duration? timeSpent,
    bool? isActive,
    bool? isCompleted,
    String? projectColor,
    bool? isArchived,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      projectName: projectName ?? this.projectName,
      assignee: assignee ?? this.assignee,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      timeSpent: timeSpent ?? this.timeSpent,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      projectColor: projectColor ?? this.projectColor,
      isArchived: isArchived ?? this.isArchived,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  fromEntity(Task task) {
    return Task(
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
      isArchived: task.isArchived,
      startTime: task.startTime,
      endTime: task.endTime,
    );
  }
}
