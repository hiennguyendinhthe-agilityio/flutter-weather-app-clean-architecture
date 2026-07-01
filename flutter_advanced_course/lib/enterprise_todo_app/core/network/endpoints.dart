import 'package:flutter_advanced_course/enterprise_todo_app/core/config/env_config.dart';

class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL được đọc từ --dart-define-from-file tại compile time.
  /// Dev   → https://dev-api.example.com
  /// Staging → https://staging-api.example.com
  /// Prod  → https://api.example.com
  static String get baseUrl => EnvConfig.apiBaseUrl;

  // Paths
  static const String todos = '/todos';
  static String todoById(int id) => '/todos/$id';

  static const String users = '/users';
  static String userById(int id) => '/users/$id';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 15);
}
