import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/todo_app/models/todo.dart';
import 'package:flutter_advanced_course/todo_app/providers/todo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoItemWidget extends ConsumerStatefulWidget {
  final Todo todo;

  const TodoItemWidget({super.key, required this.todo});

  @override
  ConsumerState<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends ConsumerState<TodoItemWidget> {
  late TextEditingController _textEditingController;
  late FocusNode _itemFocusNode;
  late FocusNode _textFieldFocusNode;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
      text: widget.todo.description,
    );
    _itemFocusNode = FocusNode();
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _itemFocusNode.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _submitEdit() {
    setState(() {
      _isEditing = false;
    });
    if (_textEditingController.text.trim().isNotEmpty) {
      ref
          .read(todoListProvider.notifier)
          .edit(widget.todo.id, _textEditingController.text.trim());
    } else {
      _textEditingController.text = widget.todo.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        focusNode: _itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            _textEditingController.text = widget.todo.description;
          } else {
            // Commit changes if we lose focus
            _submitEdit();
          }
        },
        child: ListTile(
          onTap: () {
            setState(() {
              _isEditing = true;
            });
            _itemFocusNode.requestFocus();
            _textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: widget.todo.isCompleted,
            onChanged: (value) {
              ref.read(todoListProvider.notifier).toggle(widget.todo.id);
            },
          ),
          title: _isEditing
              ? TextField(
                  controller: _textEditingController,
                  focusNode: _textFieldFocusNode,
                  decoration: const InputDecoration(border: InputBorder.none),
                  onSubmitted: (_) => _submitEdit(),
                  autofocus: true,
                )
              : Text(
                  widget.todo.description,
                  style: TextStyle(
                    decoration: widget.todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: widget.todo.isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              ref.read(todoListProvider.notifier).remove(widget.todo.id);
            },
          ),
        ),
      ),
    );
  }
}
