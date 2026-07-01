import 'package:flutter_advanced_course/enterprise_todo_app/core/error/app_exception.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/logger/app_logger.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/storage/hive_client.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/models/todo_model.dart';
import 'package:hive/hive.dart';

class TodoLocalDatasource {
  Future<Box<Map>> get _box => HiveClient.openTodosBox();

  Future<void> saveAll(List<TodoModel> todos) async {
    try {
      final box = await _box;

      final entries = {for (final todo in todos) todo.id: todo.toHive()};
      await box.putAll(entries);
      AppLogger.debug('Local: saved ${todos.length} todos to cache');
    } catch (e, st) {
      AppLogger.error('Local: save failed', e, st);
      throw CacheException(originalError: e);
    }
  }

  Future<List<TodoModel>> getAll() async {
    try {
      final box = await _box;
      final todos = box.values.map((map) => TodoModel.fromHive(map)).toList();
      AppLogger.debug('Local: loaded ${todos.length} todos from cache');
      return todos;
    } catch (e, st) {
      AppLogger.error('Local: getAll failed', e, st);
      throw CacheException(originalError: e);
    }
  }

  Future<void> save(TodoModel todo) async {
    try {
      final box = await _box;
      await box.put(todo.id, todo.toHive());
      AppLogger.debug('Local: saved todo #${todo.id}');
    } catch (e, st) {
      AppLogger.error('Local: save single failed', e, st);
      throw CacheException(originalError: e);
    }
  }

  Future<void> delete(int id) async {
    try {
      final box = await _box;
      await box.delete(id);
      AppLogger.debug('Local: deleted todo #$id');
    } catch (e, st) {
      AppLogger.error('Local: delete failed', e, st);
      throw CacheException(originalError: e);
    }
  }

  Future<bool> get hasData async {
    final box = await _box;
    return box.isNotEmpty;
  }
}
