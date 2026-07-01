import 'package:flutter_advanced_course/enterprise_todo_app/core/config/env_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cấu hình toàn bộ app được đọc từ --dart-define-from-file
/// Inject qua Riverpod để mọi layer đều truy cập được.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.environment,
    required this.enableLogging,
    required this.enableCrashlytics,
    required this.appName,
  });

  final String apiBaseUrl;
  final AppEnvironment environment;
  final bool enableLogging;
  final bool enableCrashlytics;
  final String appName;

  /// Đọc toàn bộ config từ dart-define (biên dịch tại compile time)
  factory AppConfig.fromEnv() => AppConfig(
    apiBaseUrl: EnvConfig.apiBaseUrl,
    environment: EnvConfig.environment,
    // String.fromEnvironment phải là literal string — đọc từng key riêng
    enableLogging:
        const String.fromEnvironment('ENABLE_LOGGING', defaultValue: 'true') ==
        'true',
    enableCrashlytics:
        const String.fromEnvironment(
          'ENABLE_CRASHLYTICS',
          defaultValue: 'false',
        ) ==
        'true',
    appName: EnvConfig.appName,
  );

  bool get isProduction => environment == AppEnvironment.production;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isDev => environment == AppEnvironment.dev;

  @override
  String toString() =>
      'AppConfig(env: $environment, url: $apiBaseUrl, logging: $enableLogging)';
}

// ─── Riverpod Provider ──────────────────────────────────────────────────────

/// Provider toàn cục cho AppConfig
/// Override trong main() nếu cần inject giá trị test
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnv();
});
