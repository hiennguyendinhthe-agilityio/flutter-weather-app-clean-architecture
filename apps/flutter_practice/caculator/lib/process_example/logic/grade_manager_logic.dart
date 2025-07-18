import 'package:flutter/foundation.dart';

import '../model/student_model.dart';

class GradeManager {
  final List<Student> _students = [];
  // Getter for the list of students
  List<Student> get students => List.unmodifiable(_students);

  // Logic: Add a new student
  void addStudent(Student student) {
    _students.add(student);
    debugPrint("✅ Added student: $student");
  }

  // Logic: Remove a student by name
  void removeStudent(int index) {
    if (index >= 0 && index < _students.length) {
      Student removed = _students.removeAt(index);
      debugPrint("❌ Removed student: $removed");
    }
  }

  double get classAverage {
    if (students.isEmpty) return 0.0;
    double totalAvg = _students
        .map((s) => s.averageGrade)
        .reduce((a, b) => a + b);
    return totalAvg / _students.length;
  }

  int get passingStudentsCount {
    return _students.where((s) => s.isPassing).length;
  }

  Student? get topStudent {
    if (_students.isEmpty) return null;
    return _students.reduce((a, b) => a.averageGrade > b.averageGrade ? a : b);
  }

  List<Student> get sortedByGrade {
    List<Student> sorted = List.from(_students);
    sorted.sort((a, b) => b.averageGrade.compareTo(a.averageGrade));
    return sorted;
  }

  Map<String, int> get gradeDistribution {
    Map<String, int> distribution = {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'F': 0};
    for (Student student in _students) {
      distribution[student.letterGrade] =
          (distribution[student.letterGrade] ?? 0) + 1;
    }
    return distribution;
  }
}
