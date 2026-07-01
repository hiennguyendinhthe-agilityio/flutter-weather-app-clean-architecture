import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/error/app_exception.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/logger/app_logger.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/auth_interceptor.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/endpoints.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/retry_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioClient {
  DioClient._();

  static Dio create(Ref ref) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final refeshDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    refeshDio.interceptors.add(_LoggingInterceptor());

    dio.interceptors.addAll([
      _LoggingInterceptor(),
      AuthInterceptor(ref),
      _ErrorInterceptor(),
      RetryInterceptor(ref),
    ]);

    return dio;
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(
      '→ ${options.method} ${options.path}\n'
      '  Headers: ${options.headers}\n'
      '  Body: ${options.data}',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      '← ${response.statusCode} ${response.requestOptions.path}\n'
      '  Data: ${response.data.toString().length > 200 ? '${response.data.toString().substring(0, 200)}...' : response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '✗ ${err.response?.statusCode} ${err.requestOptions.path}: ${err.message}',
      err,
      err.stackTrace,
    );
    super.onError(err, handler);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapDioException(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        response: err.response,
        type: err.type,
      ),
    );
  }

  AppException _mapDioException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(originalError: err);

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          return UnauthorizedException(originalError: err);
        } else if (statusCode == 404) {
          return const NotFoundException(message: 'Data not found.');
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: 'Server error ($statusCode). Please try again.',
            statusCode: statusCode,
            originalError: err,
          );
        } else {
          return ServerException(
            message: 'Unknown error from server.',
            statusCode: statusCode,
            originalError: err,
          );
        }

      case DioExceptionType.cancel:
        return UnknownException(
          message: 'Request cancelled.',
          originalError: err,
        );

      default:
        return UnknownException(originalError: err);
    }
  }
}
