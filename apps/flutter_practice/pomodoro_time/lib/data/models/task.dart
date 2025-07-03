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
  final String? note;
  final String? musicTitle;
  final String? musicArtist;

  Task({
    required this.id,
    required this.title,
    required this.projectName,
    required this.assignee,
    required this.tags,
    required this.createdAt,
    required this.timeSpent,
    required this.isActive,
    required this.isCompleted,
    required this.projectColor,
    required this.isArchived,
    required this.startTime,
    required this.endTime,
    this.note,
    this.musicTitle,
    this.musicArtist,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      projectName: json['projectName'],
      assignee: json['assignee'],
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      timeSpent: Duration(milliseconds: json['timeSpent'] ?? 0),
      isActive: json['isActive'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      projectColor: json['projectColor'] ?? 'blue',
      isArchived: json['isArchived'] ?? false,
      startTime: DateTime.tryParse(json['startTime'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] ?? '') ?? DateTime.now(),
      note: json['note'],
      musicTitle: json['musicTitle'],
      musicArtist: json['musicArtist'],
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
      'note': note,
      'musicTitle': musicTitle,
      'musicArtist': musicArtist,
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
    String? note,
    String? musicTitle,
    String? musicArtist,
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
      note: note ?? this.note,
      musicTitle: musicTitle ?? this.musicTitle,
      musicArtist: musicArtist ?? this.musicArtist,
    );
  }
}
