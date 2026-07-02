import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/auth_interceptor.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/dio_client.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/endpoints.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/retry_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'DioClient.create configures Dio with expected options and interceptors',
    () {
      final container = ProviderContainer();
      final dioProvider = Provider<Dio>((ref) => DioClient.create(ref));
      final dio = container.read(dioProvider);

      expect(dio.options.baseUrl, ApiEndpoints.baseUrl);
      expect(dio.options.connectTimeout, ApiEndpoints.connectTimeout);
      expect(dio.options.receiveTimeout, ApiEndpoints.receiveTimeout);
      expect(dio.options.headers['Content-Type'], 'application/json');
      expect(dio.interceptors.whereType<AuthInterceptor>(), isNotEmpty);
      expect(dio.interceptors.whereType<RetryInterceptor>(), isNotEmpty);
    },
  );
}
