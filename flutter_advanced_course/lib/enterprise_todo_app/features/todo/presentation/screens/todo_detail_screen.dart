import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_detail_notifier.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_list_notifier.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/widgets/priority_badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoDetailScreen extends ConsumerStatefulWidget {
  final int todoId;
  const TodoDetailScreen({super.key, required this.todoId});

  @override
  ConsumerState<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  Priority? _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();

    _titleController.addListener(() => setState(() {}));
    _noteController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _initFormFrom(TodoEntity todo) {
    if (_selectedPriority == null) {
      _titleController.text = todo.title;
      _noteController.text = todo.note ?? '';
      _selectedPriority = todo.priority;
    }
  }

  bool _checkHasChanges(TodoEntity original) {
    if (_selectedPriority == null) return false;

    final currentTitle = _titleController.text.trim();
    final currentNote = _noteController.text.trim();

    return currentTitle != original.title ||
        currentNote != (original.note ?? '') ||
        _selectedPriority != original.priority;
  }

  Future<void> _save(TodoEntity original) async {
    final updated = original.copyWith(
      title: _titleController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      priority: _selectedPriority ?? Priority.medium,
    );

    try {
      await ref.read(todoListNotifierProvider.notifier).updateTodo(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task has been updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating task'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoAsync = ref.watch(todoDetailProvider(widget.todoId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          if (todoAsync.value != null && _checkHasChanges(todoAsync.value!))
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.icon(
                icon: const Icon(Icons.save_rounded, size: 18),
                label: const Text('Save'),
                onPressed: () => _save(todoAsync.value!),
              ),
            ),
        ],
      ),
      body: todoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (todo) {
          _initFormFrom(todo);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusBanner(isCompleted: todo.isCompleted),
                const SizedBox(height: 24),

                Text('Title', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),

                TextField(
                  controller: _titleController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Enter a task title...',
                  ),
                ),
                const SizedBox(height: 20),

                Text('Note', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: const InputDecoration(hintText: 'Add a note...'),
                ),
                const SizedBox(height: 20),

                Text('Priority', style: theme.textTheme.labelLarge),
                const SizedBox(height: 12),
                _PrioritySelector(
                  selected: _selectedPriority ?? Priority.medium,
                  onChanged: (p) {
                    setState(() {
                      _selectedPriority = p;
                    });
                  },
                ),
                const SizedBox(height: 24),

                _MetaInfo(todo: todo),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final bool isCompleted;
  const _StatusBanner({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.pending_rounded,
            color: isCompleted ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 10),
          Text(
            isCompleted ? 'Completed' : 'In progress',
            style: TextStyle(
              color: isCompleted ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final Priority selected;
  final ValueChanged<Priority> onChanged;
  const _PrioritySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Priority.values.map((p) {
        final isSelected = p == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    PriorityBadge(priority: p),
                    const SizedBox(height: 4),
                    Text(
                      p.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MetaInfo extends StatelessWidget {
  final TodoEntity todo;
  const _MetaInfo({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _InfoRow(label: 'ID', value: '#${todo.id}'),
          if (todo.createdAt != null)
            _InfoRow(
              label: 'Created at',
              value:
                  '${todo.createdAt!.day}/${todo.createdAt!.month}/${todo.createdAt!.year}',
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
