import 'package:caculator/thinking_process_example.dart';
import 'package:flutter/material.dart';

class StudentGradenScreen extends StatefulWidget {
  const StudentGradenScreen({super.key});

  @override
  State<StudentGradenScreen> createState() => _StudentGradenScreenState();
}

class _StudentGradenScreenState extends State<StudentGradenScreen> {
  final GradeManager _gradeManager = GradeManager();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Grade Manager'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          _buildStatisCard(),

          _buildInputForm(),

          Expanded(child: _buildStudentList()),
        ],
      ),
    );
  }

  Widget _buildStatisCard() {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Class statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Students',
                  '${_gradeManager.students.length}',
                  Colors.blue,
                ),
                _buildStatItem(
                  'Class Avg',
                  _gradeManager.classAverage.toStringAsFixed(1),
                  Colors.green,
                ),
                _buildStatItem(
                  'Passing',
                  '${_gradeManager.passingStudentsCount}',
                  Colors.orange,
                ),
              ],
            ),
            if (_gradeManager.topStudent != null) ...[
              SizedBox(height: 10),
              Text(
                '🏆 Top Student: ${_gradeManager.topStudent!.name} (${_gradeManager.topStudent!.averageGrade.toStringAsFixed(1)})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInputForm() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _gradesController,
              decoration: InputDecoration(
                labelText: 'Grades (comma separated: e.g. 85,90,78)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addStudent,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }

  void _addStudent() {
    String name = _nameController.text.trim();
    String gradesText = _gradesController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter student name');
      return;
    }

    if (gradesText.isEmpty) {
      _showError('Please enter grades');
      return;
    }

    try {
      List<double> grades = gradesText
          .split(',')
          .map((s) => double.parse(s.trim()))
          .toList();

      for (double grade in grades) {
        if (grade < 0 || grade > 100) {
          _showError('Grades must be between 0 and 100');
          return;
        }
      }
      Student student = Student(name: name, grades: grades);

      setState(() {
        _gradeManager.addStudent(student);
      });
      _nameController.clear();
      _gradesController.clear();
      _showSuccess('Student added successfully');
    } catch (e) {
      _showError(
        'Invalid grades format. Please use numbers separated by commas.',
      );
    }
  }

  Widget _buildStudentList() {
    if (_gradeManager.students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64, color: Colors.grey),
            Text('No students added yet', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    List<Student> sortedStudents = _gradeManager.sortedByGrade;

    return ListView.builder(
      itemCount: sortedStudents.length,
      itemBuilder: (context, index) {
        Student student = sortedStudents[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: student.gradeColor,
              child: Text(
                student.letterGrade,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              student.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Average: ${student.averageGrade.toStringAsFixed(1)} | Grades: ${student.grades.join(", ")}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  student.isPassing ? Icons.check_circle : Icons.cancel,
                  color: student.isPassing ? Colors.green : Colors.red,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeStudent(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeStudent(int index) {
    setState(() {
      _gradeManager.removeStudent(index);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
