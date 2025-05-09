// lib/data/datasources/local_data_source.dart
import 'dart:convert';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_management_app/data/models/pomodoro_model.dart';
import 'package:task_management_app/data/models/task_model.dart';

abstract class LocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<PomodoroModel?> getLastPomodoro();
  Future<void> savePomodoro(PomodoroModel pomodoro);
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;
  final Database database;

  LocalDataSourceImpl({
    required this.sharedPreferences,
    required this.database,
  });

  static Future<LocalDataSourceImpl> create() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'task_management.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tasks table
        await db.execute(
          '''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            projectName TEXT,
            assignee TEXT,
            tags TEXT,
            createdAt INTEGER,
            timeSpent INTEGER,
            isActive INTEGER,
            isCompleted INTEGER,
            projectColor TEXT
          )
          ''',
        );

        // Create pomodoro table
        await db.execute(
          '''
          CREATE TABLE pomodoro(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            duration INTEGER,
            remainingTime INTEGER,
            isRunning INTEGER,
            currentTaskId TEXT,
            timestamp INTEGER,
            FOREIGN KEY (currentTaskId) REFERENCES tasks (id)
          )
          ''',
        );
      },
    );

    return LocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
      database: database,
    );
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final taskMaps = await database.query('tasks');

    return taskMaps.map((map) {
      final tagsJson = map['tags'] as String;
      final List<String> tags = List<String>.from(json.decode(tagsJson));

      return TaskModel(
        id: map['id'] as String,
        title: map['title'] as String,
        projectName: map['projectName'] as String,
        assignee: map['assignee'] as String,
        tags: tags,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        timeSpent: Duration(milliseconds: map['timeSpent'] as int),
        isActive: map['isActive'] == 1,
        isCompleted: map['isCompleted'] == 1,
        projectColor: map['projectColor'] as String,
      );
    }).toList();
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    await database.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'projectName': task.projectName,
        'assignee': task.assignee,
        'tags': json.encode(task.tags),
        'createdAt': task.createdAt.millisecondsSinceEpoch,
        'timeSpent': task.timeSpent.inMilliseconds,
        'isActive': task.isActive ? 1 : 0,
        'isCompleted': task.isCompleted ? 1 : 0,
        'projectColor': task.projectColor,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await database.update(
      'tasks',
      {
        'title': task.title,
        'projectName': task.projectName,
        'assignee': task.assignee,
        'tags': json.encode(task.tags),
        'createdAt': task.createdAt.millisecondsSinceEpoch,
        'timeSpent': task.timeSpent.inMilliseconds,
        'isActive': task.isActive ? 1 : 0,
        'isCompleted': task.isCompleted ? 1 : 0,
        'projectColor': task.projectColor,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<PomodoroModel?> getLastPomodoro() async {
    final pomodoroMaps = await database.query(
      'pomodoro',
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (pomodoroMaps.isEmpty) {
      return null;
    }

    final map = pomodoroMaps.first;
    final currentTaskId = map['currentTaskId'] as String?;

    TaskModel? currentTask;
    if (currentTaskId != null) {
      final taskMaps = await database.query(
        'tasks',
        where: 'id = ?',
        whereArgs: [currentTaskId],
      );

      if (taskMaps.isNotEmpty) {
        final taskMap = taskMaps.first;
        final tagsJson = taskMap['tags'] as String;
        final List<String> tags = List<String>.from(json.decode(tagsJson));

        currentTask = TaskModel(
          id: taskMap['id'] as String,
          title: taskMap['title'] as String,
          projectName: taskMap['projectName'] as String,
          assignee: taskMap['assignee'] as String,
          tags: tags,
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(taskMap['createdAt'] as int),
          timeSpent: Duration(milliseconds: taskMap['timeSpent'] as int),
          isActive: taskMap['isActive'] == 1,
          isCompleted: taskMap['isCompleted'] == 1,
          projectColor: taskMap['projectColor'] as String,
        );
      }
    }

    return PomodoroModel(
      duration: map['duration'] as int,
      remainingTime: map['remainingTime'] as int,
      isRunning: map['isRunning'] == 1,
      currentTask: currentTask,
    );
  }

  @override
  Future<void> savePomodoro(PomodoroModel pomodoro) async {
    await database.insert(
      'pomodoro',
      {
        'duration': pomodoro.duration,
        'remainingTime': pomodoro.remainingTime,
        'isRunning': pomodoro.isRunning ? 1 : 0,
        'currentTaskId': pomodoro.currentTask?.id,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
