import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/local_storage/storage_providers.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/theme/app_theme.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/screens/todo_detail_screen.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/screens/todo_list_screen.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/screens/todo_stats_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initContainer = ProviderContainer();
  final hiveService = initContainer.read(hiveStorageServiceProvider);
  await hiveService.init();
  final settingsBox = hiveService.getUserBox();

  final appContainer = ProviderContainer(
    overrides: [
      authLocalDataSourceProvider.overrideWithValue(
        AuthLocalDatasourceImpl(settingsBox),
      ),

      hiveStorageServiceProvider.overrideWithValue(hiveService),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: appContainer,
      child: const EnterpriseTodoApp(),
    ),
  );
}

class EnterpriseTodoApp extends ConsumerWidget {
  const EnterpriseTodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Enterprise Todo Hub',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      initialRoute: authState.user == null ? '/login' : '/',

      onGenerateRoute: (settings) {
        final user = ref.read(authProvider).user;
        final isLoggedIn = user != null;

        if (!isLoggedIn && settings.name != '/login') {
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }

        return switch (settings.name) {
          '/login' => MaterialPageRoute(builder: (_) => const LoginScreen()),
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
