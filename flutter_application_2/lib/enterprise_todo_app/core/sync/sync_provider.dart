import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/todo/presentation/providers/todo_providers.dart';
import 'sync_queue_datasource.dart';
import 'sync_service.dart';

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
