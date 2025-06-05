import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:task_management_app/core/audio_service.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/models/pomodoro.dart';
import 'package:task_management_app/data/models/task.dart';

class PomodoroProvider extends ChangeNotifier {
  final LocalDataSourceImpl localDataSource;

  late final AudioService _audioService;

  final List<String> _songUrls = [
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  ];

  final List<String> _songTitles = [
    'Begin Again',
    'Song 2',
    'Song 3',
  ];

  final List<String> _songArtists = [
    'Taylor Swift',
    'Artist 2',
    'Artist 3',
  ];

  Timer? _timer;

  Pomodoro? _pomodoro;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isCompleted = false;
  String? _errorMessage;

  int? _currentSongIndex;

  String get currentSongTitle =>
      _audioService.getCurrentTitle(_currentSongIndex, _songTitles);

  String get currentSongArtist =>
      _audioService.getCurrentArtist(_currentSongIndex, _songArtists);

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

  PomodoroProvider({required this.localDataSource}) {
    _audioService = AudioService(
      urls: _songUrls,
    );
    _initAudio();
  }
  bool _audioReady = false;

  Future<void> _initAudio() async {
    await _audioService.initPlaylist(loopPlaylist: true);
    _audioReady = true;

    _audioService.sequenceStateStream.listen((sequence) {
      final index = sequence?.currentIndex;
      if (index != null && index < _songTitles.length) {
        _currentSongIndex = index;
        notifyListeners();
      }
    });
  }

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
    if (!_audioReady) {
      await _initAudio();
    }
    await _audioService.play();

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

    if (_isRunning && _pomodoro != null && _pomodoro!.remainingTime > 0) {
      final updatedPomodoro = _pomodoro!.copyWith(isRunning: false);
      _pomodoro = updatedPomodoro;
      _isRunning = false;
      _isPaused = true;

      await _audioService.pause();

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

      await _audioService.play();
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

    await _audioService.stop();
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
      await _audioService.play();

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
    await _audioService.pause();

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
        await _audioService.stop();

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
    _audioService.stop();
    _audioService.dispose();
    super.dispose();
  }
}
