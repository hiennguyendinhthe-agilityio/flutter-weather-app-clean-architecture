import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Priority.fromString handles different casing and unknown', () {
    expect(Priority.fromString('High'), Priority.high);
    expect(Priority.fromString('low'), Priority.low);
    expect(Priority.fromString('MeDiUm'), Priority.medium);
    expect(Priority.fromString('unknown'), Priority.medium); // fallback
  });
}
