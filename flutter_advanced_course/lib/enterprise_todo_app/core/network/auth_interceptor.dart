import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/error/app_exception.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  bool _isRefreshing = false;
  Completer<String>? _refreshTokenCompleter;

  AuthInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final localDataSource = _ref.read(authLocalDataSourceProvider);
    final user = await localDataSource.getAuthData();
    if (user != null && user.token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${user.token}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      if (requestOptions.extra['isRetry'] == true) {
        return handler.next(err);
      }

      if (_isRefreshing) {
        try {
          final newToken = await _refreshTokenCompleter?.future;
          if (newToken != null) {
            final response = await _retryRequest(requestOptions, newToken);
            return handler.resolve(response);
          }
        } catch (e) {
          return handler.next(err);
        }
      }

      _isRefreshing = true;
      _refreshTokenCompleter = Completer<String>();
      _refreshTokenCompleter?.future.ignore();

      try {
        final authRepository = _ref.read(authRepositoryProvider);
        final updatedUser = await authRepository.refreshToken();

        _ref.read(authProvider.notifier).updateAuthenticatedUser(updatedUser);

        final newToken = updatedUser.token;
        _refreshTokenCompleter?.complete(newToken);

        _isRefreshing = false;

        final response = await _retryRequest(requestOptions, newToken);
        return handler.resolve(response);
      } catch (refreshError) {
        _refreshTokenCompleter?.completeError(refreshError);
        _isRefreshing = false;

        _ref.read(authProvider.notifier).forceLogout();

        final appException = UnauthorizedException(originalError: refreshError);
        return handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: appException,
            response: err.response,
            type: err.type,
          ),
        );
      }
    }
    handler.next(err);
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String token,
  ) {
    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
      extra: {...requestOptions.extra, 'isRetry': true},
    );

    final dio = _ref.read(dioProvider);
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
