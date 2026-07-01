import 'package:flutter_advanced_course/enterprise_todo_app/core/network/connectivity_service.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/pending_action.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/sync_queue_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/sync_service.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/models/todo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSyncQueueDatasource extends Mock implements SyncQueueDatasource {}

class MockTodoRemoteDatasource extends Mock implements TodoRemoteDatasource {}

class MockTodoLocalDatasource extends Mock implements TodoLocalDatasource {}

class MockConnectivityService extends Mock implements ConnectivityService {}

PendingAction _makePendingAction({
  ActionType type = ActionType.toggle,
  int todoId = 1,
  int retryCount = 0,
  Map<String, dynamic>? payload,
}) {
  return PendingAction(
    id: 'action-$todoId-${type.name}',
    type: type,
    todoId: todoId,
    payload: payload ?? {'title': 'Test Todo', 'isCompleted': true},
    createdAt: DateTime(2024, 1, 1),
    retryCount: retryCount,
  );
}

final _mockTodoModel = TodoModel(
  id: 99,
  title: 'New Todo',
  isCompleted: false,
  createdAt: DateTime(2024, 1, 1),
);

void main() {
  setUpAll(() {
    registerFallbackValue(_makePendingAction());
    registerFallbackValue(_mockTodoModel);
  });

  late MockSyncQueueDatasource mockQueue;
  late MockTodoRemoteDatasource mockRemote;
  late MockTodoLocalDatasource mockLocal;
  late MockConnectivityService mockConnectivity;
  late SyncService sut;

  setUp(() {
    mockQueue = MockSyncQueueDatasource();
    mockRemote = MockTodoRemoteDatasource();
    mockLocal = MockTodoLocalDatasource();
    mockConnectivity = MockConnectivityService();

    when(
      () => mockConnectivity.connectivityStream,
    ).thenAnswer((_) => const Stream.empty());

    sut = SyncService(
      queue: mockQueue,
      remote: mockRemote,
      local: mockLocal,
      connectivity: mockConnectivity,
    );
  });

  tearDown(() => sut.dispose());

  group('processQueue()', () {
    test('should no emit syncStatus when queue is empty', () async {
      when(() => mockQueue.getAll()).thenAnswer((_) async => []);

      final statuses = <SyncStatus>[];
      sut.statusStream.listen(statuses.add);

      await sut.processQueue();

      expect(statuses, isEmpty, reason: 'No events when queue is empty');
    });

    test(
      'should emit SyncStatus.syncing → done when all actions success',
      () async {
        final action = _makePendingAction(type: ActionType.toggle);
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(
          () => mockRemote.updateTodo(any(), any()),
        ).thenAnswer((_) async => _mockTodoModel);
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        final statusFuture = sut.statusStream.take(2).toList();
        await sut.processQueue();
        final statuses = await statusFuture;

        expect(statuses, [SyncStatus.syncing, SyncStatus.done]);
      },
    );

    test(
      'should emit SyncStatus.syncing → failed when at least one action fail',
      () async {
        final action = _makePendingAction(
          type: ActionType.toggle,
          retryCount: 2,
        );
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(
          () => mockRemote.updateTodo(any(), any()),
        ).thenThrow(Exception('Network error'));
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        final statusFuture = sut.statusStream.take(2).toList();
        await sut.processQueue();
        final statuses = await statusFuture;

        expect(statuses, [SyncStatus.syncing, SyncStatus.failed]);
      },
    );
  });

  group('Retry Logic', () {
    test(
      'should call queue.update() with retryCount + 1 when fail and retryCount < maxRetries',
      () async {
        final action = _makePendingAction(
          type: ActionType.toggle,
          retryCount: 0,
        );
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(
          () => mockRemote.updateTodo(any(), any()),
        ).thenThrow(Exception('Timeout'));

        PendingAction? updatedAction;
        when(() => mockQueue.update(any())).thenAnswer((invocation) async {
          updatedAction = invocation.positionalArguments[0] as PendingAction;
        });

        await sut.processQueue();

        verify(() => mockQueue.update(any())).called(1);
        verifyNever(() => mockQueue.dequeue(any()));
        expect(
          updatedAction?.retryCount,
          equals(1),
          reason: 'retryCount should be incremented by 1',
        );
      },
    );

    test(
      'should call queue.dequeue() when fail and retryCount >= maxRetries',
      () async {
        final action = _makePendingAction(
          type: ActionType.toggle,
          retryCount: 2,
        );
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(
          () => mockRemote.updateTodo(any(), any()),
        ).thenThrow(Exception('Permanent error'));
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        await sut.processQueue();

        verify(() => mockQueue.dequeue(action.id)).called(1);
        verifyNever(() => mockQueue.update(any()));
      },
    );

    test(
      'when success: should call queue.dequeue() to remove action from queue',
      () async {
        final action = _makePendingAction(type: ActionType.toggle);
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(
          () => mockRemote.updateTodo(any(), any()),
        ).thenAnswer((_) async => _mockTodoModel);
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        await sut.processQueue();

        verify(() => mockQueue.dequeue(action.id)).called(1);
        verifyNever(() => mockQueue.update(any()));
      },
    );
  });

  group('Action Types', () {
    test(
      'should call remote.createTodo() then local.save() for ActionType.create',
      () async {
        final createPayload = {'title': 'New Todo', 'isCompleted': false};
        final action = _makePendingAction(
          type: ActionType.create,
          todoId: 1,
          payload: createPayload,
        );
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(
          () => mockRemote.createTodo(any()),
        ).thenAnswer((_) async => _mockTodoModel);
        when(() => mockLocal.save(any())).thenAnswer((_) async {});
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        await sut.processQueue();

        verify(() => mockRemote.createTodo(createPayload)).called(1);
        verify(() => mockLocal.save(_mockTodoModel)).called(1);
      },
    );

    test(
      'should call remote.updateTodo() with payload for ActionType.toggle',
      () async {
        final togglePayload = {'isCompleted': true};
        final action = _makePendingAction(
          type: ActionType.toggle,
          todoId: 42,
          payload: togglePayload,
        );
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(
          () => mockRemote.updateTodo(any(), any()),
        ).thenAnswer((_) async => _mockTodoModel);
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        await sut.processQueue();

        verify(() => mockRemote.updateTodo(42, togglePayload)).called(1);
      },
    );

    test(
      'should call remote.updateTodo() with payload for ActionType.update',
      () async {
        final updatePayload = {'title': 'Updated title', 'priority': 'high'};
        final action = _makePendingAction(
          type: ActionType.update,
          todoId: 7,
          payload: updatePayload,
        );
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(
          () => mockRemote.updateTodo(any(), any()),
        ).thenAnswer((_) async => _mockTodoModel);
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        await sut.processQueue();

        verify(() => mockRemote.updateTodo(7, updatePayload)).called(1);
      },
    );

    test(
      'should call remote.deleteTodo() with todoId for ActionType.delete',
      () async {
        final action = _makePendingAction(type: ActionType.delete, todoId: 5);
        when(() => mockQueue.getAll()).thenAnswer((_) async => [action]);
        when(() => mockRemote.deleteTodo(any())).thenAnswer((_) async {});
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        await sut.processQueue();

        verify(() => mockRemote.deleteTodo(5)).called(1);
      },
    );
  });

  group('Mixed Queue Processing', () {
    test(
      'should process multiple actions, failed 1 → SyncStatus.failed finally',
      () async {
        final successAction = _makePendingAction(
          type: ActionType.delete,
          todoId: 1,
        );
        final failAction = _makePendingAction(
          type: ActionType.toggle,
          todoId: 2,
          retryCount: 2,
        );

        when(
          () => mockQueue.getAll(),
        ).thenAnswer((_) async => [successAction, failAction]);
        when(() => mockRemote.deleteTodo(1)).thenAnswer((_) async {});
        when(
          () => mockRemote.updateTodo(2, any()),
        ).thenThrow(Exception('fail'));
        when(() => mockQueue.dequeue(any())).thenAnswer((_) async {});

        final statusFuture = sut.statusStream.take(2).toList();
        await sut.processQueue();
        final statuses = await statusFuture;

        expect(statuses.last, SyncStatus.failed);
        verify(() => mockQueue.dequeue(successAction.id)).called(1);
        verify(() => mockQueue.dequeue(failAction.id)).called(1);
      },
    );
  });
}
