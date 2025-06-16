import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/notification_service.dart';

/// Pomodoro timer widget with circular progress indicator
class PomodoroTimer extends StatefulWidget {
  final VoidCallback? onClose;

  const PomodoroTimer({
    super.key,
    this.onClose,
  });

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer>
    with TickerProviderStateMixin {
  static const int _pomodoroMinutes = 25;
  static const int _shortBreakMinutes = 5;
  static const int _longBreakMinutes = 15;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Timer? _timer;
  int _remainingSeconds = _pomodoroMinutes * 60;
  bool _isRunning = false;
  bool _isBreak = false;
  int _completedPomodoros = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 200,
        height: 280,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTimer(),
            const SizedBox(height: 16),
            _buildControls(),
            const SizedBox(height: 8),
            _buildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _isBreak ? 'Break Time' : 'Focus Time',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _isBreak ? Colors.green : Colors.red,
          ),
        ),
        IconButton(
          onPressed: widget.onClose,
          icon: const Icon(Icons.close, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    final progress = _remainingSeconds / (_getCurrentSessionMinutes() * 60);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          children: [
            CircularProgressIndicator(
              value: 1 - progress,
              strokeWidth: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _isBreak ? Colors.green : Colors.red,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_remainingSeconds),
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _isRunning ? 'Running' : 'Paused',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: _reset,
          icon: const Icon(Icons.refresh),
          tooltip: 'Reset',
        ),
        IconButton(
          onPressed: _toggleTimer,
          icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
          tooltip: _isRunning ? 'Pause' : 'Start',
          iconSize: 32,
        ),
        IconButton(
          onPressed: _skip,
          icon: const Icon(Icons.skip_next),
          tooltip: 'Skip',
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Column(
      children: [
        Text(
          'Completed: $_completedPomodoros',
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: (_completedPomodoros % 4) / 4,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 4),
        Text(
          'Until long break: ${4 - (_completedPomodoros % 4)}',
          style: GoogleFonts.roboto(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _startTimer();
      _animationController.repeat(reverse: true);
    } else {
      _pauseTimer();
      _animationController.stop();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _completeSession();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _reset() {
    _timer?.cancel();
    _animationController.stop();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _getCurrentSessionMinutes() * 60;
    });
  }

  void _skip() {
    _completeSession();
  }

  void _completeSession() {
    _timer?.cancel();
    _animationController.stop();

    setState(() {
      _isRunning = false;

      if (!_isBreak) {
        _completedPomodoros++;
        _isBreak = true;

        // Determine break type
        if (_completedPomodoros % 4 == 0) {
          _remainingSeconds = _longBreakMinutes * 60;
        } else {
          _remainingSeconds = _shortBreakMinutes * 60;
        }

        NotificationService.showNotification(
          'Pomodoro Complete!',
          'Time for a break. You\'ve completed $_completedPomodoros pomodoros.',
        );
      } else {
        _isBreak = false;
        _remainingSeconds = _pomodoroMinutes * 60;

        NotificationService.showNotification(
          'Break Complete!',
          'Time to focus! Start your next pomodoro.',
        );
      }
    });
  }

  int _getCurrentSessionMinutes() {
    if (_isBreak) {
      return _completedPomodoros % 4 == 0
          ? _longBreakMinutes
          : _shortBreakMinutes;
    } else {
      return _pomodoroMinutes;
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
