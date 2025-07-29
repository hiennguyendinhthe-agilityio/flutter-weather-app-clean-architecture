import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../core/exceptions/api_exceptions.dart';
import 'logger_service.dart';

/// Dio Configuration Service
/// Cung cấp configured Dio instance với interceptors và error handling
@singleton
class DioService {
  final LoggerService _loggerService;
  late final Dio _dio;

  DioService(this._loggerService) {
    _dio = _createDio();
    _setupInterceptors();
    _loggerService.logInfo('[DioService] Initialized with base URL: ${_dio.options.baseUrl}');
  }

  /// Get configured Dio instance
  Dio get dio => _dio;

  /// Create Dio instance with base configuration
  Dio _createDio() {
    final dio = Dio(BaseOptions(
      // Base URL cho API thật của em
      baseUrl: 'https://66e29593494df9a478e23cab.mockapi.io/api/v1', // Em's MockAPI
      
      // Timeouts
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      
      // Headers
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      
      // Response type
      responseType: ResponseType.json,
      
      // Follow redirects
      followRedirects: true,
      maxRedirects: 3,
    ));

    return dio;
  }

  /// Setup interceptors for logging, auth, and error handling
  void _setupInterceptors() {
    // Request/Response Logging Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _loggerService.logInfo(
            '[API Request] ${options.method.toUpperCase()} ${options.uri}',
          );
          if (options.data != null) {
            _loggerService.logInfo('[API Request Data] ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          _loggerService.logInfo(
            '[API Response] ${response.statusCode} ${response.requestOptions.uri}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          _loggerService.logError(
            '[API Error] ${error.requestOptions.method.toUpperCase()} '
            '${error.requestOptions.uri} - ${error.message}',
          );
          handler.next(error);
        },
      ),
    );

    // Authentication Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // TODO: Add authentication token if available
          // final token = getStoredToken();
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          handler.next(options);
        },
      ),
    );

    // Error Handling Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final apiException = _handleDioError(error);
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: apiException,
            type: error.type,
            response: error.response,
          ));
        },
      ),
    );
  }

  /// Convert DioException to custom ApiException
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.',
        );

      case DioExceptionType.badResponse:
        return _handleHttpError(error.response!);

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.unknown:
        return NetworkException(
          message: 'Lỗi không xác định: ${error.message}',
        );

      default:
        return ApiException(
          message: error.message ?? 'Unknown error occurred',
          code: 'UNKNOWN_ERROR',
        );
    }
  }

  /// Handle HTTP status code errors
  ApiException _handleHttpError(Response response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Try to extract error message from response
    String message = 'HTTP Error $statusCode';
    String? code;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
      code = data['code']?.toString();
    }

    switch (statusCode) {
      case 400:
        return ClientException(
          message: message,
          code: code ?? 'BAD_REQUEST',
          statusCode: statusCode,
        );

      case 401:
        return UnauthorizedException(
          message: message,
          code: code,
        );

      case 403:
        return ForbiddenException(
          message: message,
          code: code,
        );

      case 404:
        return NotFoundException(
          message: message,
          code: code,
        );

      case 422:
        Map<String, List<String>>? errors;
        if (data is Map<String, dynamic> && data['errors'] != null) {
          errors = Map<String, List<String>>.from(
            data['errors'].map((key, value) => MapEntry(
              key,
              List<String>.from(value is List ? value : [value.toString()]),
            )),
          );
        }
        return ValidationException(
          message: message,
          code: code,
          errors: errors,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server error. Vui lòng thử lại sau.',
          code: code ?? 'SERVER_ERROR',
          statusCode: statusCode,
        );

      default:
        if (statusCode >= 400 && statusCode < 500) {
          return ClientException(
            message: message,
            code: code ?? 'CLIENT_ERROR',
            statusCode: statusCode,
          );
        } else if (statusCode >= 500) {
          return ServerException(
            message: message,
            code: code ?? 'SERVER_ERROR',
            statusCode: statusCode,
          );
        } else {
          return ApiException(
            message: message,
            code: code ?? 'HTTP_ERROR',
            statusCode: statusCode,
          );
        }
    }
  }

  /// Update base URL (useful for different environments)
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    _loggerService.logInfo('[DioService] Base URL updated to: $baseUrl');
  }

  /// Add authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _loggerService.logInfo('[DioService] Auth token set');
  }

  /// Remove authentication token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
    _loggerService.logInfo('[DioService] Auth token cleared');
  }
}