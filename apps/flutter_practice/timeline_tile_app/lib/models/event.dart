import 'package:flutter/material.dart';

/// Represents a timeline event with all necessary properties
///
/// This model contains event data including timing, display properties,
/// and metadata for rendering in the timeline view.
class TimelineEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final IconData icon;
  final String category;
  final bool isAllDay;
  final int priority; // 1-5, where 5 is highest priority

  const TimelineEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.icon,
    required this.category,
    this.isAllDay = false,
    this.priority = 3,
  });

  /// Duration of the event in minutes
  int get durationInMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// Hour of the day when event starts (0-23)
  int get startHour => startTime.hour;

  /// Minute within the start hour (0-59)
  int get startMinute => startTime.minute;

  /// Hour of the day when event ends (0-23)
  int get endHour => endTime.hour;

  /// Minute within the end hour (0-59)
  int get endMinute => endTime.minute;

  /// Check if this event overlaps with another event
  bool overlapsWith(TimelineEvent other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }

  /// Create a copy of this event with modified properties
  TimelineEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    Color? color,
    IconData? icon,
    String? category,
    bool? isAllDay,
    int? priority,
  }) {
    return TimelineEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      isAllDay: isAllDay ?? this.isAllDay,
      priority: priority ?? this.priority,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimelineEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TimelineEvent(id: $id, title: $title, startTime: $startTime, endTime: $endTime)';
  }
}

/// Predefined event categories with colors and icons
class EventCategory {
  static const work = EventCategory._('Work', Colors.blue, Icons.work);
  static const personal =
      EventCategory._('Personal', Colors.green, Icons.person);
  static const health = EventCategory._('Health', Colors.red, Icons.favorite);
  static const education =
      EventCategory._('Education', Colors.purple, Icons.school);
  static const social = EventCategory._('Social', Colors.orange, Icons.people);
  static const travel = EventCategory._('Travel', Colors.teal, Icons.flight);

  final String name;
  final Color color;
  final IconData icon;

  const EventCategory._(this.name, this.color, this.icon);

  static List<EventCategory> get all => [
        work,
        personal,
        health,
        education,
        social,
        travel,
      ];
}
