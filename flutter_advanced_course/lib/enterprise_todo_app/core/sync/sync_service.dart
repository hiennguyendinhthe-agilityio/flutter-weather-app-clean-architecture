import 'dart:async';

import 'package:flutter_advanced_course/enterprise_todo_app/core/logger/app_logger.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/connectivity_service.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/pending_action.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/sync_queue_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_remote_datasource.dart';

enum SyncStatus { idle, syncing, done, failed }

class SyncService {
  final SyncQueueDatasource _queue;
  final TodoRemoteDatasource _remote;
  final TodoLocalDatasource _local;
  final ConnectivityService _connectivity;

  final _statusController = StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get statusStream => _statusController.stream;

  StreamSubscription<bool>? _connectivitySub;
  static const int _maxRetries = 3;

  SyncService({
    required SyncQueueDatasource queue,
    required TodoRemoteDatasource remote,
    required TodoLocalDatasource local,
    required ConnectivityService connectivity,
  }) : _queue = queue,
       _remote = remote,
       _local = local,
       _connectivity = connectivity;

  void start() {
    _connectivitySub = _connectivity.connectivityStream.listen((
      isOnline,
    ) async {
      if (isOnline) {
        AppLogger.info(
          'SyncService: Online, attempting to sync pending actions...',
        );
        await processQueue();
      }
    });
    AppLogger.info('SyncService: started,');
  }

  void dispose() {
    _connectivitySub?.cancel();
    _statusController.close();
  }

  Future<void> processQueue() async {
    final actions = await _queue.getAll();
    if (actions.isEmpty) {
      AppLogger.debug('SyncService: No pending actions');
      return;
    }

    _statusController.add(SyncStatus.syncing);
    AppLogger.info(
      'SyncService: processing ${actions.length} pending action(s)',
    );

    bool allSuccess = true;

    for (final action in actions) {
      final succes = await _processAction(action);

      if (!succes) {
        allSuccess = false;
      }
    }

    _statusController.add(allSuccess ? SyncStatus.done : SyncStatus.failed);
  }

  Future<bool> _processAction(PendingAction action) async {
    try {
      switch (action.type) {
        case ActionType.create:
          await _syncCreate(action);
        case ActionType.toggle:
          await _syncToggle(action);
        case ActionType.update:
          await _syncUpdate(action);
        case ActionType.delete:
          await _syncDelete(action);
      }
      await _queue.dequeue(action.id);
      AppLogger.info(
        'SyncService: synced ${action.type.name} for todo ${action.todoId}',
      );
      return true;
    } catch (e) {
      AppLogger.warning(
        'SyncService: failed to sync ${action.type.name} for todo #${action.todoId} '
        '(attempt ${action.retryCount + 1}/$_maxRetries): $e',
      );

      if (action.retryCount + 1 >= _maxRetries) {
        AppLogger.error(
          'SyncService: giving up on action ${action.id} after $_maxRetries retries',
        );
        await _queue.dequeue(action.id);
      } else {
        await _queue.update(action.incrementRetry());
      }
      return false;
    }
  }

  Future<void> _syncCreate(PendingAction action) async {
    if (action.payload == null) return;
    final created = await _remote.createTodo(action.payload!);
    await _local.save(created);
  }

  Future<void> _syncToggle(PendingAction action) async {
    if (action.payload == null) return;
    await _remote.updateTodo(action.todoId, action.payload!);
  }

  Future<void> _syncUpdate(PendingAction action) async {
    if (action.payload == null) return;
    await _remote.updateTodo(action.todoId, action.payload!);
  }

  Future<void> _syncDelete(PendingAction action) async {
    await _remote.deleteTodo(action.todoId);
  }
}
