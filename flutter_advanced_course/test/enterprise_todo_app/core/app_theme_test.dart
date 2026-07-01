import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('priorityColor maps priorities to expected colors', () {
    expect(AppTheme.priorityColor('high'), AppTheme.error);
    expect(AppTheme.priorityColor('medium'), AppTheme.warning);
    expect(AppTheme.priorityColor('low'), AppTheme.success);
    expect(AppTheme.priorityColor('something'), const Color(0xFF718096));
  });

  testWidgets('light theme has expected scaffold background', (tester) async {
    final theme = AppTheme.light;
    expect(theme.scaffoldBackgroundColor, const Color(0xFFF7FAFC));
    expect(theme.appBarTheme.backgroundColor, Colors.white);
  });
}
