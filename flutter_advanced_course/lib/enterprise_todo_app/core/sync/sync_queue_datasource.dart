import 'package:flutter_advanced_course/enterprise_todo_app/core/logger/app_logger.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/pending_action.dart';
import 'package:hive/hive.dart';

class SyncQueueDatasource {
  static const String _boxName = 'pending_queue_box';

  Future<Box<Map>> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Map>(_boxName);
    }
    return await Hive.openBox<Map>(_boxName);
  }

  Future<void> enqueue(PendingAction action) async {
    try {
      final box = await _box;
      await box.put(action.id, action.toHive());
      AppLogger.debug(
        'SyncQueue: enqueued ${action.type.name} for todo #${action.todoId}',
      );
    } catch (e, st) {
      AppLogger.error('SyncQueue: enqueue failed', e, st);
    }
  }

  Future<void> dequeue(String actionId) async {
    try {
      final box = await _box;
      await box.delete(actionId);
      AppLogger.debug('SyncQueue: dequeued action $actionId');
    } catch (e, st) {
      AppLogger.error('SyncQueue: dequeue failed', e, st);
    }
  }

  Future<void> update(PendingAction action) async {
    try {
      final box = await _box;
      await box.put(action.id, action.toHive());
    } catch (e, st) {
      AppLogger.error('SyncQueue: update failed', e, st);
    }
  }

  Future<List<PendingAction>> getAll() async {
    try {
      final box = await _box;
      final actions =
          box.values.map((map) => PendingAction.fromHive(map)).toList()
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return actions;
    } catch (e, st) {
      AppLogger.error('SyncQueue: getAll failed', e, st);
      return [];
    }
  }

  Future<void> clear() async {
    final box = await _box;
    await box.clear();
    AppLogger.info('SyncQueue: cleared all pending actions');
  }

  Future<int> get count async {
    final box = await _box;
    return box.length;
  }
}
