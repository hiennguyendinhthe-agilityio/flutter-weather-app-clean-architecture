// lib/main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_management_app/core/di/injection_container.dart' as di;
import 'package:task_management_app/core/themes/app_theme.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_bloc.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_event.dart';
import 'package:task_management_app/presentation/blocs/task/task_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_event.dart';
import 'package:task_management_app/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit(); // Khởi tạo FFI bindings
  databaseFactory = databaseFactoryFfi;
  // Initialize dependency injection
  await di.init();
  if (kIsWeb) {
    // Dành riêng cho nền tảng Web
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => di.sl<TaskBloc>()..add(LoadTasksEvent()),
        ),
        BlocProvider<PomodoroBloc>(
          create: (context) =>
              di.sl<PomodoroBloc>()..add(LoadLastPomodoroEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Task Management App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
