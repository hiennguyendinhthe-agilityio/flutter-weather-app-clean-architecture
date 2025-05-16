import 'dart:convert';
import 'dart:ui';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_management_app/data/models/pomodoro.dart';
import 'package:task_management_app/data/models/setting.dart';
import 'package:task_management_app/data/models/task.dart';

class LocalDataSourceImpl {
  final SharedPreferences sharedPreferences;
  final Database database;

  LocalDataSourceImpl({
    required this.sharedPreferences,
    required this.database,
  });
  Future<bool> saveSettings(PomodoroSettings settings) async {
    final Map<String, dynamic> settingsMap = {
      'pomodoroTime': settings.pomodoroTime,
      'shortBreakTime': settings.shortBreakTime,
      'longBreakTime': settings.longBreakTime,
      'longBreakInterval': settings.longBreakInterval,
      'autoStartBreaks': settings.autoStartBreaks,
      'autoStartPomodoros': settings.autoStartPomodoros,
      'autoCheckTasks': settings.autoCheckTasks,
      'autoSwitchTasks': settings.autoSwitchTasks,
      'alarmSound': settings.alarmSound,
      'alarmVolume': settings.alarmVolume,
      'alarmRepeat': settings.alarmRepeat,
      'tickingSound': settings.tickingSound,
      'tickingVolume': settings.tickingVolume,
      'themeColor': settings.themeColor.value,
    };

    final String settingsJson = jsonEncode(settingsMap);
    return await sharedPreferences.setString('pomodoro_settings', settingsJson);
  }

  Future<PomodoroSettings?> getSettings() async {
    final String? settingsJson =
        sharedPreferences.getString('pomodoro_settings');

    if (settingsJson != null) {
      final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);

      return PomodoroSettings(
        pomodoroTime: settingsMap['pomodoroTime'] ?? 25,
        shortBreakTime: settingsMap['shortBreakTime'] ?? 5,
        longBreakTime: settingsMap['longBreakTime'] ?? 15,
        longBreakInterval: settingsMap['longBreakInterval'] ?? 4,
        autoStartBreaks: settingsMap['autoStartBreaks'] ?? false,
        autoStartPomodoros: settingsMap['autoStartPomodoros'] ?? false,
        autoCheckTasks: settingsMap['autoCheckTasks'] ?? false,
        autoSwitchTasks: settingsMap['autoSwitchTasks'] ?? false,
        alarmSound: settingsMap['alarmSound'] ?? 'Digital',
        alarmVolume: settingsMap['alarmVolume'] ?? 50,
        alarmRepeat: settingsMap['alarmRepeat'] ?? 1,
        tickingSound: settingsMap['tickingSound'] ?? 'None',
        tickingVolume: settingsMap['tickingVolume'] ?? 50,
        themeColor: Color(settingsMap['themeColor'] ?? 0xFF2196F3),
      );
    }

    return null;
  }

  static Future<LocalDataSourceImpl> create() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'task_management.db');

    final database = await openDatabase(
      path,
      version: 2,
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
            projectColor TEXT,
            isArchived INTEGER DEFAULT 0
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
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            '''
            ALTER TABLE tasks ADD COLUMN isArchived INTEGER DEFAULT 0
            ''',
          );
        }
      },
    );

    return LocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
      database: database,
    );
  }

  Future<List<Task>> getTasks() async {
    final taskMaps = await database.query('tasks');

    return taskMaps.map((map) {
      final tagsJson = map['tags'] as String? ?? '[]';
      final List<String> tags = List<String>.from(json.decode(tagsJson));

      return Task(
        id: map['id'] as String,
        title: map['title'] as String,
        projectName: map['projectName'] as String,
        assignee: map['assignee'] as String,
        tags: tags,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        timeSpent: Duration(milliseconds: map['timeSpent'] as int),
        isActive: (map['isActive'] as int? ?? 0) == 1,
        isCompleted: (map['isCompleted'] as int? ?? 0) == 1,
        projectColor: map['projectColor'] as String,
        isArchived: (map['isArchived'] as int? ?? 0) == 1,
      );
    }).toList();
  }

  Future<void> saveTask(Task task) async {
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
        'isArchived': task.isArchived ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
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
        'isArchived': task.isArchived ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Pomodoro?> getLastPomodoro() async {
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

    Task? currentTask;
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

        currentTask = Task(
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

    return Pomodoro(
      duration: map['duration'] as int,
      remainingTime: map['remainingTime'] as int,
      isRunning: map['isRunning'] == 1,
      currentTask: currentTask,
    );
  }

  Future<void> savePomodoro(Pomodoro pomodoro) async {
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
