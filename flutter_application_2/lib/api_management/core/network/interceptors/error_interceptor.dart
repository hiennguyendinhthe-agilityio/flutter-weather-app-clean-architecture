import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // We can handle specific status codes here (e.g., 500, 404, 403)
    // and map them to custom exceptions or show global snackbars.
    // We pass 401 through because AuthInterceptor will handle token refresh.

    if (err.response != null) {
      switch (err.response?.statusCode) {
        case 403:
          // Handle Forbidden
          debugPrint('Forbidden access. You do not have permission.');
          break;
        case 404:
          // Handle Not Found
          debugPrint('Resource not found.');
          break;
        case 500:
          // Handle Internal Server Error
          debugPrint('Internal server error.');
          break;
      }
    } else {
      // No response, could be network error, timeout etc.
      debugPrint('Network error: ${err.message}');
    }

    super.onError(err, handler);
  }
}
