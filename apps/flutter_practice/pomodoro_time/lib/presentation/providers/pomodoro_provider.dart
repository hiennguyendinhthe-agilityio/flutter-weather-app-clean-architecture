// ✅ Refactored PomodoroProvider with accurate timer tracking using DateTime
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
  DateTime? _startTime;

  Pomodoro? _pomodoro;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isCompleted = false;
  String? _errorMessage;
  int? _currentSongIndex;
  bool _isLoading = false;
  bool _audioReady = false;

  PomodoroProvider({required this.localDataSource}) {
    _audioService = AudioService(urls: _songUrls);
    _initAudio();
  }

  bool get isLoading => _isLoading;
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _initAudio() async {
    try {
      await _audioService.initPlaylist(loopPlaylist: true);
      _audioReady = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initAudio: $e');
    }
    _audioService.currentIndexStream.listen((index) {
      if (index != null && index < _songTitles.length) {
        _currentSongIndex = index;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioService.stop();
    _audioService.dispose();
    super.dispose();
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
          _startTime = DateTime.now().subtract(Duration(
              seconds: pomodoro.duration * 60 - pomodoro.remainingTime));
          _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
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
    if (_isRunning || _isLoading) return;
    if (!_audioReady) {
      _setLoading(true);
      await _initAudio();
      _setLoading(false);
    }
    if (_isRunning) return;

    final duration = _pomodoro?.duration ?? 25;
    final newPomodoro = Pomodoro(
      duration: duration,
      remainingTime: duration * 60,
      isRunning: true,
      currentTask: task,
    );
    _pomodoro = newPomodoro;
    _startTime = DateTime.now();
    _isRunning = true;
    _isPaused = false;
    _isCompleted = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    notifyListeners();

    try {
      await _audioService.play();
    } catch (e) {
      debugPrint('Audio start error: $e');
    }

    try {
      await localDataSource.savePomodoro(newPomodoro);
    } catch (e) {
      _errorMessage = 'Failed to save pomodoro: $e';
      notifyListeners();
    }
  }

  Future<void> pausePomodoro() async {
    _timer?.cancel();
    if (_isRunning && _pomodoro != null && _pomodoro!.remainingTime > 0) {
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      final updatedPomodoro = _pomodoro!.copyWith(
        isRunning: false,
        remainingTime: (_pomodoro!.duration * 60 - elapsed)
            .clamp(0, _pomodoro!.duration * 60),
      );
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
      _startTime = DateTime.now().subtract(Duration(
          seconds: _pomodoro!.duration * 60 - _pomodoro!.remainingTime));
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
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
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
    _currentSongIndex = null;
    _audioReady = false;
    _startTime = null;
    notifyListeners();
    try {
      await _audioService.stop();
      await _audioService.seekToStart();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
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
      _startTime = DateTime.now();
      notifyListeners();
      await _audioService.play();
      try {
        await localDataSource.savePomodoro(resetPomodoro);
      } catch (e) {
        _errorMessage = 'Failed to save reset pomodoro: $e';
        notifyListeners();
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    }
  }

  Future<void> setPomodoroDuration(int minutes) async {
    _timer?.cancel();
    await _audioService.stop();
    await _audioService.seekToStart();
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
    _startTime = null;
    notifyListeners();
    try {
      await localDataSource.savePomodoro(newPomodoro);
    } catch (e) {
      _errorMessage = 'Failed to save pomodoro duration: $e';
      notifyListeners();
    }
  }

  void _onTick() async {
    if (_isRunning && _pomodoro != null && _startTime != null) {
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      final newRemaining = (_pomodoro!.duration * 60 - elapsed)
          .clamp(0, _pomodoro!.duration * 60);

      if (newRemaining != _pomodoro!.remainingTime) {
        _pomodoro = _pomodoro!.copyWith(remainingTime: newRemaining);
        notifyListeners();

        if (newRemaining == 0) {
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
        } else if (newRemaining % 60 == 0) {
          try {
            await localDataSource.savePomodoro(_pomodoro!);
          } catch (e) {
            _errorMessage = 'Failed to save pomodoro time: $e';
            notifyListeners();
          }
        }
      }
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
