import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_list_notifier.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoDetailProvider = FutureProvider.autoDispose.family<TodoEntity, int>((
  ref,
  id,
) async {
  final listState = ref.watch(todoListNotifierProvider);

  final found = listState.value?.items.where((t) => t.id == id).firstOrNull;
  if (found != null) {
    return found;
  }

  return ref.read(todoRepositoryProvider).getTodoById(id);
});
