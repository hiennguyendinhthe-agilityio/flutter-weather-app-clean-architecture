import 'package:flutter_advanced_course/enterprise_todo_app/core/logger/app_logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxNames {
  HiveBoxNames._();
  static const String todos = 'todos_box';
  static const String settings = 'settings_box';
}

class HiveClient {
  HiveClient._();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();
    AppLogger.info('Hive initialized');
    _initialized = true;
  }

  static Future<Box<Map>> openTodosBox() async {
    if (Hive.isBoxOpen(HiveBoxNames.todos)) {
      return Hive.box<Map>(HiveBoxNames.todos);
    }
    final box = await Hive.openBox<Map>(HiveBoxNames.todos);
    AppLogger.debug('Hive box opened: ${HiveBoxNames.todos}');
    return box;
  }

  static Future<Box<dynamic>> openSettingsBox() async {
    if (Hive.isBoxOpen(HiveBoxNames.settings)) {
      return Hive.box(HiveBoxNames.settings);
    }
    return Hive.openBox(HiveBoxNames.settings);
  }

  static Future<void> closeAll() async {
    await Hive.close();
    AppLogger.info('All Hive boxes closed');
  }
}
