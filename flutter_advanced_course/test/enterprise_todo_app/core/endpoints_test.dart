import 'package:flutter_advanced_course/enterprise_todo_app/core/config/env_config.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/endpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ApiEndpoints constants and helpers', () {
    expect(ApiEndpoints.baseUrl, EnvConfig.apiBaseUrl);
    expect(ApiEndpoints.todos, '/todos');
    expect(ApiEndpoints.todoById(5), '/todos/5');
    expect(ApiEndpoints.users, '/users');
    expect(ApiEndpoints.userById(7), '/users/7');
    expect(ApiEndpoints.connectTimeout.inSeconds, 15);
    expect(ApiEndpoints.receiveTimeout.inSeconds, 20);
    expect(ApiEndpoints.sendTimeout.inSeconds, 15);
  });
}
