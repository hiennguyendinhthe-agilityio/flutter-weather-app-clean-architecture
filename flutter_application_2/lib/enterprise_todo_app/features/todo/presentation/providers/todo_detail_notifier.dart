import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/todo_entity.dart';
import 'todo_list_notifier.dart';
import 'todo_providers.dart';

final todoDetailProvider = FutureProvider.autoDispose.family<TodoEntity, int>((
  ref,
  id,
) async {
  final listState = ref.watch(todoListNotifierProvider);

  final found = listState.value?.where((t) => t.id == id).firstOrNull;
  if (found != null) {
    return found;
  }

  return ref.read(todoRepositoryProvider).getTodoById(id);
});
