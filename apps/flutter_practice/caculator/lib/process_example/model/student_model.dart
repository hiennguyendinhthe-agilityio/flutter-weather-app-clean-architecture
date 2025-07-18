import 'package:flutter/material.dart';

class Student {
  final String name;
  final List<double> grades;

  Student({required this.name, required this.grades});

  // Returns the full name of the student
  double get averageGrade {
    if (grades.isEmpty) return 0.0;
    double sum = grades.reduce((a, b) => a + b);
    return sum / grades.length;
  }

  // Returns the letter grade based on the average grade

  String get letterGrade {
    double avg = averageGrade;
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return 'F';
  }

  // Returns a color based on the letter grade

  Color get gradeColor {
    switch (letterGrade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  // Logic: State Management
  bool get isPassing => averageGrade >= 60;

  @override
  String toString() {
    return 'Student{name: $name, averageGrade: ${averageGrade.toStringAsFixed(1)}, letterGrade: $letterGrade, isPassing: $isPassing,}';
  }
}
