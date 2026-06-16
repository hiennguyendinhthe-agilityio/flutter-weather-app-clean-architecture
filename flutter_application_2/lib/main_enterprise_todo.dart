import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'enterprise_todo_app/core/storage/hive_client.dart';
import 'enterprise_todo_app/core/theme/app_theme.dart';
import 'enterprise_todo_app/features/todo/presentation/screens/todo_detail_screen.dart';
import 'enterprise_todo_app/features/todo/presentation/screens/todo_list_screen.dart';
import 'enterprise_todo_app/features/todo/presentation/screens/todo_stats_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveClient.init();

  runApp(const ProviderScope(child: EnterpriseTodoApp()));
}

class EnterpriseTodoApp extends StatelessWidget {
  const EnterpriseTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enterprise Todo Hub',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      initialRoute: '/',
      onGenerateRoute: (settings) {
        return switch (settings.name) {
          '/' => MaterialPageRoute(builder: (_) => const TodoListScreen()),
          '/detail' => MaterialPageRoute(
            builder: (_) => TodoDetailScreen(todoId: settings.arguments as int),
          ),
          '/stats' => MaterialPageRoute(
            builder: (_) => const TodoStatsScreen(),
          ),
          _ => MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('404 — Page not found')),
            ),
          ),
        };
      },
    );
  }
}
