import 'dart:ui';

class Project {
  final String id;
  final String name;
  final Color color;
  final String? avatarUrl;

  Project({
    required this.id,
    required this.name,
    required this.color,
    this.avatarUrl,
  });
}
