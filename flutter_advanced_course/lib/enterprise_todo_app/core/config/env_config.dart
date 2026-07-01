enum AppEnvironment { dev, staging, production }

class EnvConfig {
  static const String _env = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static AppEnvironment get environment => switch (_env) {
    'staging' => AppEnvironment.staging,
    'production' => AppEnvironment.production,
    _ => AppEnvironment.dev,
  };

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Todo Dev',
  );

  static bool get isProduction => environment == AppEnvironment.production;
  static bool get isDev => environment == AppEnvironment.dev;
}
