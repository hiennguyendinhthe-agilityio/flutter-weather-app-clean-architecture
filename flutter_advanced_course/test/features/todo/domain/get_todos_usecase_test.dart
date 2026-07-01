// ============================================================
// UNIT TEST — GetTodosUseCase
//
// WHY test UseCase, không test Repository hay UI?
// → UseCase chứa business logic (sorting, validation)
// → Nếu test chỉ ở UI level: chậm, fragile, khó debug
// → Test ở tầng thấp nhất chứa logic = nhanh nhất
//
// TEST STRUCTURE — AAA Pattern (Arrange, Act, Assert):
//   ARRANGE: Setup mock, chuẩn bị input
//   ACT:     Gọi function cần test
//   ASSERT:  Kiểm tra kết quả
//
// MOCK với Mocktail:
//   class MockTodoRepository extends Mock implements TodoRepository {}
//   → Tạo "fake" implementation tự động
//   → Không cần network, không cần Hive
//   → Test chạy trong <10ms
//
// INTERVIEW: "Bạn viết test cho Clean Architecture thế nào?"
//   → Test từng layer độc lập với mock của layer dưới
//   → Domain (UseCase): mock Repository
//   → Presentation (Notifier): mock UseCase
//   → Integration test: chạy từ UI xuống đến mock API
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/usecases/get_todos_usecase.dart';

// ─── Mock ──────────────────────────────────────────────────
class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late GetTodosUseCase sut; // System Under Test
  late MockTodoRepository mockRepository;

  setUp(() {
    // ARRANGE (setup chung cho mỗi test)
    mockRepository = MockTodoRepository();
    sut = GetTodosUseCase(mockRepository);
  });

  // Helper để tạo TodoEntity nhanh
  TodoEntity makeTodo({
    int id = 1,
    String title = 'Test todo',
    bool isCompleted = false,
    Priority priority = Priority.medium,
  }) => TodoEntity(
    id: id,
    title: title,
    isCompleted: isCompleted,
    priority: priority,
  );

  group('GetTodosUseCase', () {
    test('should return sorted todos (high priority first)', () async {
      // ARRANGE
      final unsortedTodos = [
        makeTodo(id: 1, priority: Priority.low),
        makeTodo(id: 2, priority: Priority.high),
        makeTodo(id: 3, priority: Priority.medium),
      ];
      // Mocktail: khi gọi getTodos() → trả về unsortedTodos
      when(
        () => mockRepository.getTodos(),
      ).thenAnswer((_) async => unsortedTodos);

      // ACT
      final result = await sut();

      // ASSERT
      expect(result.length, 3);
      expect(result[0].priority, Priority.high); // high trước
      expect(result[1].priority, Priority.medium); // medium giữa
      expect(result[2].priority, Priority.low); // low sau
    });

    test('should call repository.getTodos() exactly once', () async {
      // ARRANGE
      when(() => mockRepository.getTodos()).thenAnswer((_) async => []);

      // ACT
      await sut();

      // ASSERT — verify số lần gọi
      verify(() => mockRepository.getTodos()).called(1);
    });

    test('should return empty list when repository returns empty', () async {
      // ARRANGE
      when(() => mockRepository.getTodos()).thenAnswer((_) async => []);

      // ACT
      final result = await sut();

      // ASSERT
      expect(result, isEmpty);
    });

    test('should propagate exception from repository', () async {
      // ARRANGE
      when(
        () => mockRepository.getTodos(),
      ).thenThrow(Exception('Network error'));

      // ASSERT — expect exception khi ACT
      expect(() => sut(), throwsException);
    });
  });
}
