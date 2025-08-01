import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../core/exceptions/app_exceptions.dart';
import '../models/api_user.dart';

@singleton
class ApiClient {
  ApiClient(this._dio) {
    _setupInterceptors();
  }
  final Dio _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          // In production, use proper logging instead of debugPrint
          debugPrint('$object');
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final exception = _handleDioError(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: exception,
            ),
          );
        },
      ),
    );
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          'No internet connection. Please check your network settings.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ?? 'Server error occurred';
        return ApiException(message, null, statusCode);

      default:
        return const NetworkException('An unexpected error occurred');
    }
  }

  Future<ApiUser> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/user', data: userData);
      return ApiUser.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw const ApiException('Failed to create user');
    }
  }

  Future<List<ApiUser>> getUserByEmail(String email) async {
    try {
      debugPrint('🌐 ApiClient: GET /user?email=$email');
      final response = await _dio.get(
        '/user',
        queryParameters: {'email': email},
      );
      debugPrint('📡 ApiClient: Response status: ${response.statusCode}');
      debugPrint('📄 ApiClient: Response data: ${response.data}');

      final List<dynamic> data = response.data;
      final users = data.map((json) {
        debugPrint('🔄 ApiClient: Parsing user JSON: $json');
        return ApiUser.fromJson(json);
      }).toList();

      debugPrint('✅ ApiClient: Successfully parsed ${users.length} users');
      return users;
    } on DioException catch (e) {
      debugPrint('❌ ApiClient: DioException - ${e.message}');
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw const ApiException('Failed to fetch user');
    } catch (e) {
      debugPrint('❌ ApiClient: Unexpected error - $e');
      throw const ApiException('Failed to fetch user');
    }
  }
}
