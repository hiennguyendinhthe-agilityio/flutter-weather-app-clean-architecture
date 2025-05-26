import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/presentation/providers/pomodoro_provider.dart';

class DurationSelector extends StatelessWidget {
  final PomodoroThemeColors themeColors;
  final List<int> timeOptions = [5, 10, 20, 25, 30, 60, 120];

  DurationSelector({required this.themeColors, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroProvider>(
      builder: (context, pomodoroProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemCount = timeOptions.length + 1;
                final itemWidth = constraints.maxWidth / itemCount;

                return Row(
                  children: List.generate(itemCount, (index) {
                    if (index == itemCount - 1) {
                      return SizedBox(
                        width: itemWidth,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              '+ Add',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final time = timeOptions[index];
                    final isSelected = pomodoroProvider.duration == time;

                    return SizedBox(
                      width: itemWidth,
                      child: GestureDetector(
                        onTap: () {
                          pomodoroProvider.setPomodoroDuration(time);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? themeColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            time.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.lightBlueAccent
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
