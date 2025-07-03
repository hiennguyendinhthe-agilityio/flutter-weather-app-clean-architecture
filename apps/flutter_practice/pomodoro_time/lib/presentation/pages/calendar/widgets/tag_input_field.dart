import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PtTagInputField extends StatefulWidget {
  const PtTagInputField({
    super.key,
    required this.tagController,
    required this.tags,
    required this.onAdd,
    required this.onRemove,
    required this.labelText,
  });

  /// Controller to handle input for new tag.
  final TextEditingController tagController;

  /// Current list of tags to display.
  final List<String> tags;

  /// Callback when a new tag is added.
  final ValueChanged<String> onAdd;

  /// Callback when an existing tag is removed.
  final ValueChanged<String> onRemove;

  /// Optional label text to display above the input field.
  final String? labelText;
  @override
  State<PtTagInputField> createState() => _PtTagInputFieldState();
}

class _PtTagInputFieldState extends State<PtTagInputField> {
  final FocusNode _textFieldFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  void _handleAdd() {
    final tag = widget.tagController.text.trim();
    if (tag.isNotEmpty && !widget.tags.contains(tag)) {
      widget.onAdd(tag);
      widget.tagController.clear();
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        widget.tagController.text.isEmpty &&
        widget.tags.isNotEmpty) {
      widget.onRemove(widget.tags.last);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.labelText ?? 'Tags',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
        ],
        KeyboardListener(
          focusNode: _keyboardListenerFocusNode,
          onKeyEvent: (event) => _handleKey(_keyboardListenerFocusNode, event),
          child: GestureDetector(
            onTap: () {
              // ensure keyboard focus is active for text input
              _textFieldFocusNode.requestFocus();
              _keyboardListenerFocusNode.requestFocus();
            },
            behavior: HitTestBehavior.translucent,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      right: 40, left: 8, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...widget.tags.map(
                        (tag) => Chip(
                          label: Text(tag),
                          onDeleted: () => widget.onRemove(tag),
                          backgroundColor: Colors.grey.shade200,
                          deleteIcon: const Icon(Icons.close, size: 16),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: IntrinsicWidth(
                          child: TextField(
                            focusNode: _textFieldFocusNode,
                            controller: widget.tagController,
                            style: Theme.of(context).textTheme.titleSmall,
                            decoration: const InputDecoration(
                              hintText: 'Add tag',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 13),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _handleAdd(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 8,
                  child: GestureDetector(
                    onTap: _handleAdd,
                    child: const Icon(Icons.add, color: Colors.black, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
