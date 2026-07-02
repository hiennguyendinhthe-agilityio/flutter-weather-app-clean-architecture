import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/logger/app_logger.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RetryInterceptor extends Interceptor {
  final Ref _ref;
  final int maxRetries;
  final Duration retryDelay;
  RetryInterceptor(
    this._ref, {
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    final isTimeout =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError;

    final isServerError =
        err.type == DioExceptionType.badResponse &&
        err.response?.statusCode == 503;

    final attempt = (requestOptions.extra['retry_attempt'] as int? ?? 0) + 1;

    if ((isTimeout || isServerError) && attempt < maxRetries) {
      requestOptions.extra['retry_attempt'] = attempt;
      final delay = retryDelay * attempt;

      AppLogger.warning(
        'Request failed: ${err.message}. Retrying attempt $attempt in ${delay.inSeconds}s',
      );
      await Future.delayed(delay);

      try {
        final dio = _ref.read(dioProvider);
        final response = await dio.request(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
            extra: requestOptions.extra,
          ),
        );
        return handler.resolve(response);
      } on DioException catch (retryErr) {
        return handler.next(retryErr);
      }
    }
    super.onError(err, handler);
  }
}
