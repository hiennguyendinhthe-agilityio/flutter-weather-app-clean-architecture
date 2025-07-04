import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:task_management_app/core/themes/app_theme.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/presentation/providers/pomodoro_provider.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';
import 'package:task_management_app/router/app_router.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  final localDataSource = await LocalDataSourceImpl.create();

  runApp(
    DevicePreview(
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                TaskProvider(localDataSource: localDataSource)..loadTasks(),
          ),
          ChangeNotifierProvider(
            create: (_) => PomodoroProvider(localDataSource: localDataSource)
              ..loadLastPomodoro(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Task Management App',
      theme: PtTheme.light,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
