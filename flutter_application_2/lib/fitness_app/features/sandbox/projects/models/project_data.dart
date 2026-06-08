import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ProjectData extends Equatable {
  final String name;
  final double percentage; // 0.0 to 1.0
  final double hours;
  final Color color;

  const ProjectData({
    required this.name,
    required this.percentage,
    required this.hours,
    required this.color,
  });

  @override
  List<Object?> get props => [name, percentage, hours, color.toARGB32()];
}

class ProjectSummary extends Equatable {
  final String title;
  final int totalHours;
  final String dateRange;
  final List<ProjectData> projects;

  const ProjectSummary({
    required this.title,
    required this.totalHours,
    required this.dateRange,
    required this.projects,
  });

  @override
  List<Object?> get props => [title, totalHours, dateRange, projects];
}
