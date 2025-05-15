// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
    () => TaskBloc(
      localDataSource: sl(),
    ),
  );

  sl.registerFactory(
    () => PomodoroBloc(
      localDataSource: sl(),
    ),
  );

  // Data sources
  final localDataSource = await LocalDataSourceImpl.create();
  sl.registerLazySingleton<LocalDataSourceImpl>(() => localDataSource);
}
