import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../services/logger_service.dart';

/// CounterProvider - Quản lý trạng thái counter với Provider pattern
/// 
/// Khác biệt với CounterService:
/// - Extends ChangeNotifier để tự động thông báo UI khi state thay đổi
/// - Không cần setState() trong widget
/// - UI tự động rebuild khi data thay đổi
@injectable
class CounterProvider extends ChangeNotifier {
  final LoggerService _loggerService;
  
  // Private state
  int _count = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Constructor với dependency injection
  CounterProvider(this._loggerService) {
    _loggerService.logInfo('[CounterProvider] Initialized');
  }

  // Getters - Public interface để truy cập state
  int get count => _count;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Tăng counter
  void increment() {
    _clearError();
    _count++;
    _loggerService.log('[CounterProvider] Counter incremented to $_count');
    
    // Thông báo cho tất cả listeners (UI) rằng state đã thay đổi
    notifyListeners();
  }

  /// Giảm counter
  void decrement() {
    _clearError();
    _count--;
    _loggerService.log('[CounterProvider] Counter decremented to $_count');
    notifyListeners();
  }

  /// Reset counter về 0
  void reset() {
    _clearError();
    _count = 0;
    _loggerService.log('[CounterProvider] Counter reset to $_count');
    notifyListeners();
  }

  /// Simulate async operation - ví dụ load data từ API
  Future<void> loadCounterFromServer() async {
    _setLoading(true);
    _clearError();
    
    try {
      _loggerService.logInfo('[CounterProvider] Loading counter from server...');
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate random success/failure
      if (DateTime.now().millisecond % 3 == 0) {
        throw Exception('Network error - failed to load counter');
      }
      
      // Simulate server response
      _count = DateTime.now().second;
      _loggerService.logInfo('[CounterProvider] Counter loaded: $_count');
      
    } catch (e) {
      _errorMessage = e.toString();
      _loggerService.logError('[CounterProvider] Error loading counter: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Clear error message
  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Clear error manually (for UI)
  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    _loggerService.logInfo('[CounterProvider] Disposed');
    super.dispose();
  }
}