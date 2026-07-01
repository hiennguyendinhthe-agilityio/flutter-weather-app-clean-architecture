import 'package:flutter_advanced_course/enterprise_todo_app/core/config/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EnvConfig defaults to dev environment and has expected defaults', () {
    expect(EnvConfig.environment, AppEnvironment.dev);
    expect(EnvConfig.isDev, isTrue);
    expect(EnvConfig.isProduction, isFalse);
    expect(EnvConfig.apiBaseUrl, 'https://jsonplaceholder.typicode.com');
    expect(EnvConfig.appName, 'Todo Dev');
  });
}
