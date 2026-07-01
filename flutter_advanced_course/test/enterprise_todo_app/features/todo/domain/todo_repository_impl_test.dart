import 'package:flutter_advanced_course/enterprise_todo_app/core/error/failure.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/connectivity_service.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/pending_action.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/sync_queue_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/models/todo_model.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements TodoRemoteDatasource {}

class MockLocal extends Mock implements TodoLocalDatasource {}

class MockConnectivity extends Mock implements ConnectivityService {}

class MockSyncQueue extends Mock implements SyncQueueDatasource {}

void main() {
  late TodoRepositoryImpl sut;
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late MockConnectivity mockConnectivity;
  late MockSyncQueue mockSyncQueue;

  final fakeTodoModel = TodoModel(
    id: 1,
    title: 'Test Todo',
    isCompleted: false,
    createdAt: DateTime(2024, 1, 1),
  );

  final fakeTodos = [fakeTodoModel];

  setUpAll(() {
    registerFallbackValue(fakeTodoModel);
    registerFallbackValue(
      PendingAction.create(type: ActionType.toggle, todoId: 1),
    );
  });

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    mockConnectivity = MockConnectivity();
    mockSyncQueue = MockSyncQueue();

    sut = TodoRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      connectivity: mockConnectivity,
      syncQueue: mockSyncQueue,
    );
  });

  group('getTodos()', () {
    test('ONLINE: should fetch from remote and save to local', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.getTodos()).thenAnswer((_) async => fakeTodos);
      when(() => mockLocal.saveAll(any())).thenAnswer((_) async {});

      final result = await sut.getTodos();

      expect(result, equals(fakeTodos));
      verify(() => mockRemote.getTodos()).called(1);
      verify(() => mockLocal.saveAll(fakeTodos)).called(1);
    });

    test('OFFLINE with cache: should return cached todos', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getAll()).thenAnswer((_) async => fakeTodos);

      final result = await sut.getTodos();

      expect(result, equals(fakeTodos));
      verifyNever(() => mockRemote.getTodos());
    });

    test('OFFLINE without cache: should throw NetworkFailure', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getAll()).thenAnswer((_) async => []);

      expect(() async => await sut.getTodos(), throwsA(isA<NetworkFailure>()));
    });
  });

  group('toggleTodo()', () {
    test('OFFLINE: should update local and enqueue action', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getAll()).thenAnswer((_) async => fakeTodos);
      when(() => mockLocal.save(any())).thenAnswer((_) async {});
      when(() => mockSyncQueue.enqueue(any())).thenAnswer((_) async {});

      final result = await sut.toggleTodo(1);

      expect(result.isCompleted, isTrue);
      verify(() => mockLocal.save(any())).called(1);
      verify(() => mockSyncQueue.enqueue(any())).called(1);
      verifyNever(() => mockRemote.updateTodo(any(), any()));
    });

    test('ONLINE: should update local and call remote', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockLocal.getAll()).thenAnswer((_) async => fakeTodos);
      when(() => mockLocal.save(any())).thenAnswer((_) async {});
      when(
        () => mockRemote.updateTodo(any(), any()),
      ).thenAnswer((_) async => fakeTodoModel);

      final result = await sut.toggleTodo(1);

      expect(result.isCompleted, isTrue);
      verify(() => mockLocal.save(any())).called(1);

      await Future.delayed(Duration.zero);
      verify(() => mockRemote.updateTodo(1, any())).called(1);
    });
  });

  group('addTodo()', () {
    test('OFFLINE: should create local temp todo and enqueue', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.save(any())).thenAnswer((_) async {});
      when(() => mockSyncQueue.enqueue(any())).thenAnswer((_) async {});

      final result = await sut.addTodo('New Task', note: 'Some note');

      expect(result.title, equals('New Task'));
      expect(result.id, isNegative);
      verify(() => mockLocal.save(any())).called(1);
      verify(() => mockSyncQueue.enqueue(any())).called(1);
    });
  });
}
