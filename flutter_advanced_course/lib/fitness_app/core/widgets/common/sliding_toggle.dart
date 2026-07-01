import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';

class SlidingToggle extends StatefulWidget {
  final List<String> options;
  final Function(int) onSelectionChanged;

  const SlidingToggle({
    super.key,
    required this.options,
    required this.onSelectionChanged,
  });

  @override
  State<SlidingToggle> createState() => _SlidingToggleState();
}

class _SlidingToggleState extends State<SlidingToggle> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.slidingToggleTheme;
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.backgroundColor ?? const Color(0xFF1A1B1E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final toggleWidth = constraints.maxWidth / widget.options.length;

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  left: _selectedIndex * toggleWidth,
                  width: toggleWidth,
                  height: constraints.maxHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.thumbColor ?? const Color(0xFF2A2B30),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                Row(
                  children: widget.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final label = entry.value;
                    final isSelected = _selectedIndex == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedIndex = index);
                          widget.onSelectionChanged(index);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Text(
                            label,
                            style: isSelected
                                ? theme.selectedTextStyle
                                : theme.textStyle,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
