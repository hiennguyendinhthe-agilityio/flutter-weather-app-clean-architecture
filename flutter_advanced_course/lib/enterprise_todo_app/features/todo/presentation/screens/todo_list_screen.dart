import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_filter_notifier.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_list_notifier.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/widgets/todo_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> {
  final _addController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _addController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(todoListNotifierProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(todoListNotifierProvider);
    final filtered = ref.watch(filteredTodosProvider);
    final filter = ref.watch(todoFilterProvider);
    final activeCount = ref.watch(activeCountProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(todoListNotifierProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              title: const Text('Todo Hub'),
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.bar_chart_rounded),
                  tooltip: 'Analytics',
                  onPressed: () => Navigator.of(context).pushNamed('/stats'),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh',
                  onPressed: todosAsync.isLoading
                      ? null
                      : () => ref
                            .read(todoListNotifierProvider.notifier)
                            .refresh(),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  _OfflineBanner(),
                  _AddTodoBar(controller: _addController),
                  _FilterBar(currentFilter: filter, activeCount: activeCount),
                ],
              ),
            ),

            todosAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),

              error: (error, _) => SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                          onPressed: () => ref
                              .read(todoListNotifierProvider.notifier)
                              .refresh(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              data: (paginatedState) {
                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No Todo found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == filtered.length) {
                          if (paginatedState.isLoadingMore) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (paginatedState.errorMessage != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                children: [
                                  Text(
                                    paginatedState.errorMessage!,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton.icon(
                                    onPressed: () => ref
                                        .read(todoListNotifierProvider.notifier)
                                        .fetchNextPage(),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Thử lại'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        }

                        final todo = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TodoCard(
                            key: ValueKey(todo.id),
                            todo: todo,
                            onToggle: () => ref
                                .read(todoListNotifierProvider.notifier)
                                .toggle(todo.id),
                            onDelete: () =>
                                _confirmDelete(context, todo.id, todo.title),
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed('/detail', arguments: todo.id),
                          ),
                        );
                      },
                      childCount:
                          filtered.length +
                          (paginatedState.hasMore ||
                                  paginatedState.isLoadingMore ||
                                  paginatedState.errorMessage != null
                              ? 1
                              : 0),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    int id,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await ref.read(todoListNotifierProvider.notifier).delete(id);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Delete failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

class _OfflineBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }
}

class _AddTodoBar extends ConsumerWidget {
  final TextEditingController controller;
  const _AddTodoBar({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Add new todo...',
                prefixIcon: Icon(Icons.add_task_rounded),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(context, ref),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: () => _submit(context, ref),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final title = controller.text.trim();
    if (title.isEmpty) return;
    controller.clear();
    FocusScope.of(context).unfocus();
    try {
      await ref.read(todoListNotifierProvider.notifier).add(title);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _FilterBar extends ConsumerWidget {
  final TodoFilter currentFilter;
  final int activeCount;
  const _FilterBar({required this.currentFilter, required this.activeCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            '$activeCount active',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const Spacer(),
          for (final f in TodoFilter.values)
            _FilterChip(
              label: f.name[0].toUpperCase() + f.name.substring(1),
              selected: currentFilter == f,
              onTap: () => ref.read(todoFilterProvider.notifier).setFilter(f),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: (_) => onTap(),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
