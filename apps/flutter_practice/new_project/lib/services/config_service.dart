import 'package:injectable/injectable.dart';

@lazySingleton
class ConfigService {
  late final String _appName;
  late final String _version;
  late final bool _isDebugMode;

  ConfigService() {
    print('[ConfigService] Constructor called - Lazy Singleton initialized');
    _appName = 'DI Learning App';
    _version = '1.0.0';
    _isDebugMode = true;
  }

  String get appName => _appName;
  String get version => _version;
  bool get isDebugMode => _isDebugMode;

  String getAppInfo() {
    return '$_appName v$_version (Debug: $_isDebugMode)';
  }
}
