// lib/data/repositories/pomodoro_repository_impl.dart
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/models/pomodoro_model.dart';
import 'package:task_management_app/domain/entities/pomodoro.dart';
import 'package:task_management_app/domain/repositories/pomodoro_repository.dart';

class PomodoroRepositoryImpl implements PomodoroRepository {
  final LocalDataSource localDataSource;

  PomodoroRepositoryImpl({required this.localDataSource});

  @override
  Future<Pomodoro?> getLastPomodoro() async {
    final pomodoroModel = await localDataSource.getLastPomodoro();
    return pomodoroModel;
  }

  @override
  Future<void> savePomodoro(Pomodoro pomodoro) async {
    final pomodoroModel = PomodoroModel.fromEntity(pomodoro);
    await localDataSource.savePomodoro(pomodoroModel);
  }
}
