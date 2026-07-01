import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/api_management/core/local_storage/token_storage.dart';
import 'package:flutter_advanced_course/api_management/features/auth/services/auth_api_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorage _tokenStorage;
  final AuthApiService _authApiService;

  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _failedRequestsQueue = [];

  AuthInterceptor(this._dio, this._tokenStorage, this._authApiService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Exclude login and refresh token endpoints from adding token
    if (options.path.contains('/login') || options.path.contains('/refresh')) {
      return handler.next(options);
    }

    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;

      // If already refreshing, queue the request
      if (_isRefreshing) {
        final completer = Completer<Response>();
        _failedRequestsQueue.add({
          'options': options,
          'handler': handler,
          'completer': completer,
        });

        // Wait for the refresh to finish
        try {
          final response = await completer.future;
          return handler.resolve(response);
        } catch (e) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Failed to queue request after refresh',
            ),
          );
        }
      }

      _isRefreshing = true;

      try {
        final refreshToken = await _tokenStorage.getRefreshToken();
        if (refreshToken == null) {
          // No refresh token available, force logout
          await _authApiService.logout();
          _isRefreshing = false;
          return handler.reject(err);
        }

        // Call the refresh API
        final newTokenModel = await _authApiService.refreshToken(refreshToken);

        // Update the failed request header with the new token
        options.headers['Authorization'] =
            'Bearer ${newTokenModel.accessToken}';

        // Retry the original request
        final retryResponse = await _dio.fetch(options);

        // Resolve queued requests
        _processFailedRequestsQueue(newTokenModel.accessToken);

        _isRefreshing = false;
        return handler.resolve(retryResponse);
      } catch (e) {
        // Refresh failed, clear tokens and logout
        await _authApiService.logout();
        _rejectFailedRequestsQueue(e);
        _isRefreshing = false;
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }

  void _processFailedRequestsQueue(String newAccessToken) {
    for (var element in _failedRequestsQueue) {
      final RequestOptions options = element['options'];
      final Completer<Response> completer = element['completer'];

      options.headers['Authorization'] = 'Bearer $newAccessToken';
      _dio
          .fetch(options)
          .then((response) {
            completer.complete(response);
            // Note: The resolve is handled in the onError wait logic
          })
          .catchError((e) {
            completer.completeError(e);
          });
    }
    _failedRequestsQueue.clear();
  }

  void _rejectFailedRequestsQueue(dynamic error) {
    for (var element in _failedRequestsQueue) {
      final Completer<Response> completer = element['completer'];
      completer.completeError(error);
    }
    _failedRequestsQueue.clear();
  }
}
