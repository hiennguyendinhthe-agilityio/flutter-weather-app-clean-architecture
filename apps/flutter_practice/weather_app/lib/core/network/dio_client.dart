// ignore_for_file: avoid_print

// Dio factory.
//
// Creates a configured [Dio] instance with:
//   - Sensible timeouts
//   - JSON content-type default
//   - LogInterceptor in debug mode only (stripped in release via assert)
//
// Rules:
//   - NO base URL set here — each Retrofit client sets its own via @RestApi.
//   - NO auth headers here — injected per-request via query param (OWM style).
//   - NO business logic.

import 'package:dio/dio.dart';

abstract final class DioClient {
  DioClient._();

  static Dio create() {
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {'Content-Type': 'application/json; charset=utf-8'},
    );

    final dio = Dio(options);

    // LogInterceptor is only added in debug builds.
    // `assert` blocks are stripped by the compiler in release mode.
    assert(() {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (object) => print('[DioClient] $object'),
        ),
      );
      return true;
    }());

    return dio;
  }
}
