import 'package:flutter/material.dart';

class ProjectData {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          percentage == other.percentage &&
          hours == other.hours &&
          color.toARGB32() == other.color.toARGB32();

  @override
  int get hashCode => name.hashCode ^ percentage.hashCode ^ hours.hashCode ^ color.toARGB32().hashCode;
}

class ProjectSummary {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectSummary &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          totalHours == other.totalHours &&
          dateRange == other.dateRange;
          // Note: Deep list comparison omitted for simplicity as dateRange/totalHours change per period
  
  @override
  int get hashCode => title.hashCode ^ totalHours.hashCode ^ dateRange.hashCode;
}
