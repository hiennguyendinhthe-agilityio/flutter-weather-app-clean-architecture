// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/repositories/pomodoro_repository_impl.dart';
import 'package:task_management_app/data/repositories/task_repository_impl.dart';
import 'package:task_management_app/domain/repositories/pomodoro_repository.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';
import 'package:task_management_app/domain/usecases/pomodoro/get_last_pomodoro.dart';
import 'package:task_management_app/domain/usecases/pomodoro/pause_pomodoro.dart';
import 'package:task_management_app/domain/usecases/pomodoro/save_pomodoro.dart';
import 'package:task_management_app/domain/usecases/pomodoro/start_pomodoro.dart';
import 'package:task_management_app/domain/usecases/pomodoro/stop_pomodoro.dart';
import 'package:task_management_app/domain/usecases/task/add_task.dart';
import 'package:task_management_app/domain/usecases/task/delete_task.dart';
import 'package:task_management_app/domain/usecases/task/get_tasks.dart';
import 'package:task_management_app/domain/usecases/task/update_task.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      addTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );

  sl.registerFactory(
    () => PomodoroBloc(
      getLastPomodoro: sl(),
      savePomodoro: sl(),
      startPomodoro: sl(),
      pausePomodoro: sl(),
      stopPomodoro: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => GetLastPomodoro(sl()));
  sl.registerLazySingleton(() => SavePomodoro(sl()));
  sl.registerLazySingleton(() => StartPomodoro(sl()));
  sl.registerLazySingleton(() => PausePomodoro(sl()));
  sl.registerLazySingleton(() => StopPomodoro(sl()));

  // Repositories
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<PomodoroRepository>(
    () => PomodoroRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  final localDataSource = await LocalDataSourceImpl.create();
  sl.registerLazySingleton<LocalDataSource>(() => localDataSource);
}
