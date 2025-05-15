import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/models/pomodoro.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_event.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  final LocalDataSourceImpl localDataSource;

  Timer? _timer;

  PomodoroBloc({required this.localDataSource}) : super(PomodoroInitial()) {
    on<StartPomodoroEvent>(_onStartPomodoro);
    on<PausePomodoroEvent>(_onPausePomodoro);
    on<ResumePomodoroEvent>(_onResumePomodoro);
    on<StopPomodoroEvent>(_onStopPomodoro);
    on<ResetPomodoroEvent>(_onResetPomodoro);
    on<SetPomodoroDurationEvent>(_onSetPomodoroDuration);
    on<PomodoroTickEvent>(_onPomodoroTick);
    on<LoadLastPomodoroEvent>(_onLoadLastPomodoro);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onLoadLastPomodoro(
      LoadLastPomodoroEvent event, Emitter<PomodoroState> emit) async {
    try {
      final pomodoro = await localDataSource.getLastPomodoro();

      if (pomodoro != null) {
        if (pomodoro.isRunning) {
          emit(PomodoroRunning(pomodoro));

          _timer = Timer.periodic(const Duration(seconds: 1), (_) {
            add(PomodoroTickEvent());
          });
        } else {
          emit(PomodoroPaused(pomodoro));
        }
      }
    } catch (e) {
      // If there's an error, just stay in the initial state
    }
  }

  Future<void> _onStartPomodoro(
      StartPomodoroEvent event, Emitter<PomodoroState> emit) async {
    _timer?.cancel();

    final pomodoro = Pomodoro(
      duration: 25, // Default 25 minutes
      remainingTime: 25 * 60, // Convert to seconds
      isRunning: true,
      currentTask: event.task,
    );

    emit(PomodoroRunning(pomodoro));

    try {
      await localDataSource.savePomodoro(pomodoro);
    } catch (e) {
      // Handle error
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(PomodoroTickEvent());
    });
  }

  Future<void> _onPausePomodoro(
      PausePomodoroEvent event, Emitter<PomodoroState> emit) async {
    _timer?.cancel();

    if (state is PomodoroRunning) {
      final currentState = state as PomodoroRunning;
      final pomodoro = currentState.pomodoro.copyWith(isRunning: false);
      emit(PomodoroPaused(pomodoro));

      try {
        await localDataSource.savePomodoro(pomodoro);
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<void> _onResumePomodoro(
      ResumePomodoroEvent event, Emitter<PomodoroState> emit) async {
    if (state is PomodoroPaused) {
      final currentState = state as PomodoroPaused;
      final pomodoro = currentState.pomodoro.copyWith(isRunning: true);
      emit(PomodoroRunning(pomodoro));

      try {
        await localDataSource.savePomodoro(pomodoro);
      } catch (e) {
        // Handle error
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        add(PomodoroTickEvent());
      });
    }
  }

  Future<void> _onStopPomodoro(
      StopPomodoroEvent event, Emitter<PomodoroState> emit) async {
    _timer?.cancel();

    if (state is PomodoroRunning || state is PomodoroPaused) {
      final currentState = state;
      Pomodoro pomodoro;

      if (currentState is PomodoroRunning) {
        pomodoro = currentState.pomodoro;
      } else {
        pomodoro = (currentState as PomodoroPaused).pomodoro;
      }

      try {
        await localDataSource.savePomodoro(pomodoro);
      } catch (e) {
        // Handle error
      }
    }

    emit(PomodoroInitial());
  }

  Future<void> _onResetPomodoro(
      ResetPomodoroEvent event, Emitter<PomodoroState> emit) async {
    _timer?.cancel();

    if (state is PomodoroRunning || state is PomodoroPaused) {
      final currentState = state;
      Pomodoro pomodoro;

      if (currentState is PomodoroRunning) {
        pomodoro = currentState.pomodoro;
      } else {
        pomodoro = (currentState as PomodoroPaused).pomodoro;
      }

      final resetPomodoro = Pomodoro(
        duration: pomodoro.duration,
        remainingTime: pomodoro.duration * 60,
        isRunning: true,
        currentTask: pomodoro.currentTask,
      );

      emit(PomodoroRunning(resetPomodoro));

      try {
        await localDataSource.savePomodoro(resetPomodoro);
      } catch (e) {
        // Handle error
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        add(PomodoroTickEvent());
      });
    }
  }

  Future<void> _onSetPomodoroDuration(
      SetPomodoroDurationEvent event, Emitter<PomodoroState> emit) async {
    _timer?.cancel();

    final pomodoro = Pomodoro(
      duration: event.minutes,
      remainingTime: event.minutes * 60,
      isRunning: false,
      currentTask: null,
    );

    emit(PomodoroPaused(pomodoro));

    try {
      await localDataSource.savePomodoro(pomodoro);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onPomodoroTick(
      PomodoroTickEvent event, Emitter<PomodoroState> emit) async {
    if (state is PomodoroRunning) {
      final currentState = state as PomodoroRunning;
      final pomodoro = currentState.pomodoro;

      if (pomodoro.remainingTime > 0) {
        final updatedPomodoro = pomodoro.copyWith(
          remainingTime: pomodoro.remainingTime - 1,
        );
        emit(PomodoroRunning(updatedPomodoro));

        // Save every minute to reduce database writes
        if (updatedPomodoro.remainingTime % 60 == 0) {
          try {
            await localDataSource.savePomodoro(updatedPomodoro);
          } catch (e) {
            // Handle error
          }
        }
      } else {
        _timer?.cancel();
        emit(PomodoroCompleted(pomodoro));

        try {
          await localDataSource
              .savePomodoro(pomodoro.copyWith(isRunning: false));
        } catch (e) {
          // Handle error
        }
      }
    }
  }
}
