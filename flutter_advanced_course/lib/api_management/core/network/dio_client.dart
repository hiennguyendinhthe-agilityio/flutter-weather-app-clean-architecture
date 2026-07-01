import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/api_management/core/local_storage/token_storage.dart';
import 'package:flutter_advanced_course/api_management/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_advanced_course/api_management/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_advanced_course/api_management/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_advanced_course/api_management/features/auth/services/auth_api_service.dart';

class DioClient {
  late final Dio _dio;

  Dio get dio => _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://mock-api.example.com/api', // Example baseUrl
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Dependencies
    final tokenStorage = TokenStorage();
    // Use a separate Dio instance for AuthApiService to prevent interceptor loops
    final authDio = Dio(
      BaseOptions(
        baseUrl: 'https://mock-api.example.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    authDio.interceptors.add(LoggingInterceptor());
    final authApiService = AuthApiService(authDio, tokenStorage);

    // Add interceptors
    // Order matters: Error -> Auth -> Logging
    _dio.interceptors.addAll([
      ErrorInterceptor(),
      AuthInterceptor(_dio, tokenStorage, authApiService),
      LoggingInterceptor(), // Log requests/responses at the end
    ]);
  }
}
