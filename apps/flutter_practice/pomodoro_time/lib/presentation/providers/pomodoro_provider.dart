import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/models/pomodoro.dart';
import 'package:task_management_app/data/models/task.dart';

class PomodoroProvider extends ChangeNotifier {
  final LocalDataSourceImpl localDataSource;

  Timer? _timer;

  Pomodoro? _pomodoro;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isCompleted = false;
  String? _errorMessage;

  Pomodoro? get pomodoro => _pomodoro;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  bool get isCompleted => _isCompleted;
  String? get errorMessage => _errorMessage;

  bool get isInitial =>
      _pomodoro == null && !_isRunning && !_isPaused && !_isCompleted;

  int get remainingTime => _pomodoro?.remainingTime ?? 0;
  int get duration => _pomodoro?.duration ?? 25;
  Task? get currentTask => _pomodoro?.currentTask;

  PomodoroProvider({required this.localDataSource});

  Future<void> loadLastPomodoro() async {
    try {
      final pomodoro = await localDataSource.getLastPomodoro();

      if (pomodoro != null) {
        _pomodoro = pomodoro;

        if (pomodoro.isRunning) {
          _isRunning = true;
          _isPaused = false;
          _isCompleted = false;

          _timer = Timer.periodic(const Duration(seconds: 1), (_) {
            _onTick();
          });
        } else {
          _isRunning = false;
          _isPaused = true;
          _isCompleted = false;
        }

        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load last pomodoro: $e';
      notifyListeners();
    }
  }

  Future<void> startPomodoro({Task? task}) async {
    _timer?.cancel();

    final newPomodoro = Pomodoro(
      duration: _pomodoro?.duration ?? 25,
      remainingTime: (_pomodoro?.duration ?? 25) * 60,
      isRunning: true,
      currentTask: task,
    );

    _pomodoro = newPomodoro;
    _isRunning = true;
    _isPaused = false;
    _isCompleted = false;

    notifyListeners();

    try {
      await localDataSource.savePomodoro(newPomodoro);
    } catch (e) {
      _errorMessage = 'Failed to save pomodoro: $e';
      notifyListeners();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onTick();
    });
  }

  Future<void> pausePomodoro() async {
    _timer?.cancel();

    if (_isRunning) {
      final updatedPomodoro = _pomodoro!.copyWith(isRunning: false);
      _pomodoro = updatedPomodoro;
      _isRunning = false;
      _isPaused = true;

      notifyListeners();

      try {
        await localDataSource.savePomodoro(updatedPomodoro);
      } catch (e) {
        _errorMessage = 'Failed to save paused pomodoro: $e';
        notifyListeners();
      }
    }
  }

  Future<void> resumePomodoro() async {
    if (_isPaused) {
      final updatedPomodoro = _pomodoro!.copyWith(isRunning: true);
      _pomodoro = updatedPomodoro;
      _isRunning = true;
      _isPaused = false;

      notifyListeners();

      try {
        await localDataSource.savePomodoro(updatedPomodoro);
      } catch (e) {
        _errorMessage = 'Failed to save resumed pomodoro: $e';
        notifyListeners();
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _onTick();
      });
    }
  }

  Future<void> stopPomodoro() async {
    _timer?.cancel();

    if (_isRunning || _isPaused) {
      try {
        if (_pomodoro != null) {
          await localDataSource.savePomodoro(_pomodoro!);
        }
      } catch (e) {
        _errorMessage = 'Failed to save stopped pomodoro: $e';
        notifyListeners();
      }
    }

    _pomodoro = null;
    _isRunning = false;
    _isPaused = false;
    _isCompleted = false;

    notifyListeners();
  }

  Future<void> resetPomodoro() async {
    _timer?.cancel();

    if (_isRunning || _isPaused) {
      final resetPomodoro = Pomodoro(
        duration: _pomodoro!.duration,
        remainingTime: _pomodoro!.duration * 60,
        isRunning: true,
        currentTask: _pomodoro!.currentTask,
      );

      _pomodoro = resetPomodoro;
      _isRunning = true;
      _isPaused = false;
      _isCompleted = false;

      notifyListeners();

      try {
        await localDataSource.savePomodoro(resetPomodoro);
      } catch (e) {
        _errorMessage = 'Failed to save reset pomodoro: $e';
        notifyListeners();
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _onTick();
      });
    }
  }

  Future<void> setPomodoroDuration(int minutes) async {
    _timer?.cancel();

    final newPomodoro = Pomodoro(
      duration: minutes,
      remainingTime: minutes * 60,
      isRunning: false,
      currentTask: _pomodoro?.currentTask,
    );

    _pomodoro = newPomodoro;
    _isRunning = false;
    _isPaused = true;
    _isCompleted = false;

    notifyListeners();

    try {
      await localDataSource.savePomodoro(newPomodoro);
    } catch (e) {
      _errorMessage = 'Failed to save pomodoro duration: $e';
      notifyListeners();
    }
  }

  void _onTick() async {
    if (_isRunning && _pomodoro != null) {
      if (_pomodoro!.remainingTime > 0) {
        final updatedPomodoro = _pomodoro!.copyWith(
          remainingTime: _pomodoro!.remainingTime - 1,
        );

        _pomodoro = updatedPomodoro;
        notifyListeners();

        if (updatedPomodoro.remainingTime % 60 == 0) {
          try {
            await localDataSource.savePomodoro(updatedPomodoro);
          } catch (e) {
            _errorMessage = 'Failed to save pomodoro time: $e';
            notifyListeners();
          }
        }
      } else {
        _timer?.cancel();
        _isRunning = false;
        _isPaused = false;
        _isCompleted = true;

        notifyListeners();

        try {
          await localDataSource
              .savePomodoro(_pomodoro!.copyWith(isRunning: false));
        } catch (e) {
          _errorMessage = 'Failed to save completed pomodoro: $e';
          notifyListeners();
        }
      }
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
