import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/todo_app/providers/todo_provider.dart';
import 'package:flutter_advanced_course/todo_app/widgets/todo_item_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);
    final textController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Riverpod To-Do',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add, color: Colors.blueAccent),
                    onPressed: () {
                      if (textController.text.trim().isNotEmpty) {
                        ref
                            .read(todoListProvider.notifier)
                            .add(textController.text.trim());
                        textController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    ref.read(todoListProvider.notifier).add(value.trim());
                    textController.clear();
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            _Toolbar(),
            const SizedBox(height: 10),
            if (todos.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No tasks found!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: todos.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey(todos[index].id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        ref
                            .read(todoListProvider.notifier)
                            .remove(todos[index].id);
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: TodoItemWidget(todo: todos[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Toolbar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoFilterStateProvider);
    final todos = ref.watch(todoListProvider);
    final activeCount = todos.where((todo) => !todo.isCompleted).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$activeCount items left',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              _FilterButton(
                filter: TodoFilter.all,
                currentFilter: filter,
                label: 'All',
              ),
              _FilterButton(
                filter: TodoFilter.active,
                currentFilter: filter,
                label: 'Active',
              ),
              _FilterButton(
                filter: TodoFilter.completed,
                currentFilter: filter,
                label: 'Completed',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends ConsumerWidget {
  final TodoFilter filter;
  final TodoFilter currentFilter;
  final String label;

  const _FilterButton({
    required this.filter,
    required this.currentFilter,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(todoFilterStateProvider.notifier).changeFilter(filter);
      },
      style: TextButton.styleFrom(
        foregroundColor: currentFilter == filter
            ? Colors.blueAccent
            : Colors.grey,
        textStyle: TextStyle(
          fontWeight: currentFilter == filter
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      child: Text(label),
    );
  }
}
