import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/sync_queue_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/sync_service.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_provider.g.dart';

@Riverpod(keepAlive: true)
SyncQueueDatasource syncQueueDatasource(Ref ref) {
  return SyncQueueDatasource();
}

@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) {
  final service = SyncService(
    queue: ref.watch(syncQueueDatasourceProvider),
    remote: ref.watch(todoRemoteDatasourceProvider),
    local: ref.watch(todoLocalDatasourceProvider),
    connectivity: ref.watch(connectivityProvider),
  );

  service.start();

  ref.onDispose(service.dispose);

  return service;
}

@riverpod
Stream<SyncStatus> syncStatus(Ref ref) {
  return ref.watch(syncServiceProvider).statusStream;
}
