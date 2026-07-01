import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/models/todo_model.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TodoModel JSON and Hive conversion and copyWith/fromEntity', () {
    final json = {
      'id': 10,
      'title': 'Write tests',
      'completed': false,
      'userId': 42,
    };

    final model = TodoModel.fromJson(json);
    expect(model.id, 10);
    expect(model.title, 'Write tests');
    expect(model.isCompleted, false);
    expect(model.userId, 42);

    final out = model.toJson();
    expect(out['id'], 10);
    expect(out['title'], 'Write tests');
    expect(out['completed'], false);

    final hiveMap = {
      'id': 11,
      'title': 'Hive Todo',
      'isCompleted': true,
      'userId': 3,
      'priority': 'high',
      'note': 'note',
      'createdAt': DateTime(2020, 1, 1).toIso8601String(),
    };

    final fromHive = TodoModel.fromHive(hiveMap);
    expect(fromHive.id, 11);
    expect(fromHive.title, 'Hive Todo');
    expect(fromHive.isCompleted, true);
    expect(fromHive.priority, Priority.high);
    expect(fromHive.note, 'note');
    expect(fromHive.createdAt, DateTime(2020, 1, 1));

    final hiveOut = fromHive.toHive();
    expect(hiveOut['priority'], 'high');
    expect(hiveOut['createdAt'], '2020-01-01T00:00:00.000');

    final entity = const TodoEntity(id: 20, title: 'E', isCompleted: false);
    final fromEntity = TodoModel.fromEntity(entity);
    expect(fromEntity.id, 20);

    final copied = fromEntity.copyWith(title: 'Changed', userId: 9);
    expect(copied.title, 'Changed');
    expect(copied.userId, 9);
  });
}
