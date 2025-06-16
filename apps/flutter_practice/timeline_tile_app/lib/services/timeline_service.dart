import 'package:flutter/material.dart';

import '../models/event.dart';

/// Service class managing timeline state and event data
///
/// Handles selected date, event filtering, and provides sample data.
/// In a real app, this would integrate with a backend API or local database.
class TimelineService extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  List<TimelineEvent> _allEvents = [];

  TimelineService() {
    _generateSampleEvents();
  }

  /// Currently selected date
  DateTime get selectedDate => _selectedDate;

  /// All events in the system
  List<TimelineEvent> get allEvents => List.unmodifiable(_allEvents);

  /// Events for the currently selected date
  List<TimelineEvent> get eventsForSelectedDate {
    return _allEvents.where((event) {
      return _isSameDay(event.startTime, _selectedDate);
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Update the selected date
  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  /// Add a new event
  void addEvent(TimelineEvent event) {
    _allEvents.add(event);
    notifyListeners();
  }

  /// Remove an event
  void removeEvent(String eventId) {
    _allEvents.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }

  /// Update an existing event
  void updateEvent(TimelineEvent updatedEvent) {
    final index = _allEvents.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _allEvents[index] = updatedEvent;
      notifyListeners();
    }
  }

  /// Get events for a specific date
  List<TimelineEvent> getEventsForDate(DateTime date) {
    return _allEvents.where((event) {
      return _isSameDay(event.startTime, date);
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Generate sample events for demonstration
  void _generateSampleEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _allEvents = [
      // Today's events
      TimelineEvent(
        id: '1',
        title: 'Morning Standup',
        description: 'Daily team sync meeting to discuss progress and blockers',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 9, minutes: 30)),
        color: EventCategory.work.color,
        icon: EventCategory.work.icon,
        category: EventCategory.work.name,
        priority: 4,
      ),
      TimelineEvent(
        id: '2',
        title: 'Flutter Development',
        description: 'Working on the timeline feature implementation',
        startTime: today.add(const Duration(hours: 10)),
        endTime: today.add(const Duration(hours: 12)),
        color: EventCategory.work.color,
        icon: Icons.code,
        category: EventCategory.work.name,
        priority: 5,
      ),
      TimelineEvent(
        id: '3',
        title: 'Lunch Break',
        description: 'Time to recharge with a healthy meal',
        startTime: today.add(const Duration(hours: 12)),
        endTime: today.add(const Duration(hours: 13)),
        color: EventCategory.personal.color,
        icon: Icons.restaurant,
        category: EventCategory.personal.name,
        priority: 2,
      ),
      TimelineEvent(
        id: '4',
        title: 'Client Meeting',
        description: 'Project review and feedback session',
        startTime: today.add(const Duration(hours: 14)),
        endTime: today.add(const Duration(hours: 15, minutes: 30)),
        color: EventCategory.work.color,
        icon: Icons.meeting_room,
        category: EventCategory.work.name,
        priority: 5,
      ),
      TimelineEvent(
        id: '5',
        title: 'Gym Workout',
        description: 'Strength training and cardio session',
        startTime: today.add(const Duration(hours: 18)),
        endTime: today.add(const Duration(hours: 19, minutes: 30)),
        color: EventCategory.health.color,
        icon: EventCategory.health.icon,
        category: EventCategory.health.name,
        priority: 3,
      ),

      // Tomorrow's events
      TimelineEvent(
        id: '6',
        title: 'Design Review',
        description: 'UI/UX review for the new features',
        startTime: today.add(const Duration(days: 1, hours: 10)),
        endTime: today.add(const Duration(days: 1, hours: 11)),
        color: EventCategory.work.color,
        icon: Icons.design_services,
        category: EventCategory.work.name,
        priority: 4,
      ),
      TimelineEvent(
        id: '7',
        title: 'Coffee with Sarah',
        description: 'Catch up with an old friend',
        startTime: today.add(const Duration(days: 1, hours: 15)),
        endTime: today.add(const Duration(days: 1, hours: 16)),
        color: EventCategory.social.color,
        icon: EventCategory.social.icon,
        category: EventCategory.social.name,
        priority: 2,
      ),

      // Yesterday's events
      TimelineEvent(
        id: '8',
        title: 'Project Planning',
        description: 'Sprint planning and task estimation',
        startTime: today.subtract(const Duration(days: 1, hours: -9)),
        endTime: today.subtract(const Duration(days: 1, hours: -11)),
        color: EventCategory.work.color,
        icon: Icons.workspaces_outline,
        category: EventCategory.work.name,
        priority: 4,
      ),
    ];
  }
}
