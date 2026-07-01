import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_item.dart';

const List<WorkoutItem> dummyWorkouts = [
  WorkoutItem(
    id: 'morning-cardio-burn',
    title: 'Morning Cardio Burn',
    durationMinutes: 25,
    targetKcal: 320,
    level: 'Medium',
    category: 'Cardio',
    icon: Icons.directions_run_rounded,
    color: Color(0xFFCBFF3E),
  ),
  WorkoutItem(
    id: 'leg-day-strength',
    title: 'Leg Day Strength',
    durationMinutes: 45,
    targetKcal: 510,
    level: 'Hard',
    category: 'Strength',
    icon: Icons.fitness_center_rounded,
    color: Color(0xFF1DE5C2),
  ),
  WorkoutItem(
    id: 'yoga-deep-stretch',
    title: 'Yoga Deep Stretch',
    durationMinutes: 30,
    targetKcal: 150,
    level: 'Easy',
    category: 'Mobility',
    icon: Icons.self_improvement_rounded,
    color: Color(0xFF5A94FF),
  ),
  WorkoutItem(
    id: 'evening-hiit-cycling',
    title: 'Evening HIIT Cycling',
    durationMinutes: 20,
    targetKcal: 280,
    level: 'Hard',
    category: 'HIIT',
    icon: Icons.directions_bike_rounded,
    color: Color(0xFFFFB347),
  ),
];
