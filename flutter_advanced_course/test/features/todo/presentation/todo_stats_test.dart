// ============================================================
// UNIT TEST — TodoStats Provider (.select optimization test)
//
// LESSON: Test rằng TodoStats CHỈ thay đổi khi count thay đổi,
//   không thay đổi khi chỉ đổi title (chứng minh .select() hoạt động)
//
// HOW test Riverpod Provider:
//   ProviderContainer: isolated Riverpod scope cho testing
//   container.read(provider): đọc giá trị
//   container.listen(provider, listener): theo dõi thay đổi
//
// Không cần WidgetTester → test chạy nhanh gấp 10x widget test
// ============================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_stats_provider.dart';

void main() {
  group('TodoStats.fromList()', () {
    test('returns zero stats for empty list', () {
      final stats = TodoStats.fromList([]);

      expect(stats.total, 0);
      expect(stats.completed, 0);
      expect(stats.active, 0);
      expect(stats.completionRate, 0.0);
    });

    test('calculates completion rate correctly', () {
      final todos = [
        const TodoEntity(id: 1, title: 'A', isCompleted: true),
        const TodoEntity(id: 2, title: 'B', isCompleted: true),
        const TodoEntity(id: 3, title: 'C', isCompleted: false),
        const TodoEntity(id: 4, title: 'D', isCompleted: false),
      ];

      final stats = TodoStats.fromList(todos);

      expect(stats.total, 4);
      expect(stats.completed, 2);
      expect(stats.active, 2);
      expect(stats.completionRate, 0.5); // 2/4 = 50%
    });

    test('counts by priority correctly', () {
      final todos = [
        const TodoEntity(
          id: 1,
          title: 'A',
          isCompleted: false,
          priority: Priority.high,
        ),
        const TodoEntity(
          id: 2,
          title: 'B',
          isCompleted: false,
          priority: Priority.high,
        ),
        const TodoEntity(
          id: 3,
          title: 'C',
          isCompleted: false,
          priority: Priority.low,
        ),
      ];

      final stats = TodoStats.fromList(todos);

      expect(stats.byPriority[Priority.high], 2);
      expect(stats.byPriority[Priority.medium], 0);
      expect(stats.byPriority[Priority.low], 1);
    });

    test(
      'Equatable: same data = same stats (enables .select optimization)',
      () {
        // Đây là test quan trọng nhất để chứng minh .select() hoạt động
        // Nếu 2 stats giống nhau → Riverpod không rebuild widget

        final todos = [
          const TodoEntity(id: 1, title: 'Original title', isCompleted: false),
        ];
        final stats1 = TodoStats.fromList(todos);

        // Đổi title nhưng giữ nguyên count
        final todosWithNewTitle = [
          const TodoEntity(id: 1, title: 'CHANGED TITLE', isCompleted: false),
        ];
        final stats2 = TodoStats.fromList(todosWithNewTitle);

        // Stats phải giống nhau → .select() sẽ skip rebuild!
        expect(stats1, equals(stats2));
      },
    );

    test('Equatable: different count = different stats (triggers rebuild)', () {
      final todosSmall = [
        const TodoEntity(id: 1, title: 'A', isCompleted: false),
      ];
      final statsSmall = TodoStats.fromList(todosSmall);

      final todosLarge = [
        const TodoEntity(id: 1, title: 'A', isCompleted: false),
        const TodoEntity(id: 2, title: 'B', isCompleted: true),
      ];
      final statsLarge = TodoStats.fromList(todosLarge);

      // Stats khác nhau → .select() sẽ trigger rebuild!
      expect(statsSmall, isNot(equals(statsLarge)));
    });
  });
}
