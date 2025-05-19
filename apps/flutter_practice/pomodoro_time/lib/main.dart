import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:task_management_app/core/di/injection_container.dart' as di;
import 'package:task_management_app/core/themes/app_theme.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_bloc.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_event.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_bloc.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_event.dart';
import 'package:task_management_app/presentation/blocs/task/task_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_event.dart';
import 'package:task_management_app/presentation/widgets/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  // Initialize dependency injection
  await di.init();

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
        BlocProvider<SettingsBloc>(
          create: (context) => di.sl<SettingsBloc>()..add(LoadSettingsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Management App',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
        home: const NavigationBarRoute(),
      ),
    );
  }
}
