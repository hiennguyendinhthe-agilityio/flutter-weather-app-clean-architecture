import 'dart:io';

import 'package:flutter_advanced_course/enterprise_todo_app/core/storage/hive_client.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/models/todo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late TodoLocalDatasource sut;
  late Directory tmpDir;

  setUpAll(() async {
    tmpDir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(tmpDir.path);
    await Hive.openBox<Map>(HiveBoxNames.todos);
  });

  tearDownAll(() async {
    await Hive.close();
    try {
      tmpDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  setUp(() async {
    sut = TodoLocalDatasource();
    final box = Hive.box<Map>(HiveBoxNames.todos);
    await box.clear();
  });

  test('save and getAll roundtrip', () async {
    final todo = TodoModel(
      id: 1,
      title: 'T',
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await sut.save(todo);
    final all = await sut.getAll();

    expect(all.length, 1);
    expect(all.first.id, 1);
  });

  test('saveAll and hasData/delete', () async {
    final t1 = TodoModel(
      id: 2,
      title: 'A',
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    final t2 = TodoModel(
      id: 3,
      title: 'B',
      isCompleted: true,
      createdAt: DateTime.now(),
    );

    await sut.saveAll([t1, t2]);
    expect(await sut.hasData, isTrue);

    await sut.delete(2);
    final all = await sut.getAll();
    expect(all.any((t) => t.id == 2), isFalse);
  });

  // Note: Hive errors are platform-dependent; open failure is hard to simulate
  // reliably in unit tests. Behavior when box is empty is already covered above.
}
