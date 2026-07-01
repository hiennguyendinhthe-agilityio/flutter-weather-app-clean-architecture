import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/api_management/core/local_storage/token_storage.dart';
import 'package:flutter_advanced_course/api_management/core/network/dio_client.dart';
import 'package:flutter_advanced_course/api_management/features/auth/services/auth_api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _dioClient = DioClient();
  final _tokenStorage = TokenStorage();
  late final AuthApiService _authApiService;

  bool _isLoading = false;
  String _statusMessage = 'Not logged in';

  @override
  void initState() {
    super.initState();
    // Using a separate dio instance for auth api to simulate what we do in DioClient
    final authDio = Dio();
    _authApiService = AuthApiService(authDio, _tokenStorage);
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final token = await _tokenStorage.getAccessToken();
    setState(() {
      if (token != null) {
        _statusMessage =
            'Logged in with Token: ${token.substring(0, min(20, token.length))}...';
      } else {
        _statusMessage = 'Not logged in';
      }
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Logging in...';
    });

    try {
      await _authApiService.login('admin', '123456');
      await _checkStatus();
    } catch (e) {
      setState(() {
        _statusMessage = 'Login failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _authApiService.logout();
    await _checkStatus();
  }

  Future<void> _callProtectedApi() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Calling protected API...';
    });

    try {
      // Simulate calling a protected API endpoint that might throw 401
      // We will intercept this call using a fake interceptor that forces a 401 once
      // to test the refresh token mechanism.

      // Let's create an error adapter to simulate network response
      _dioClient.dio.httpClientAdapter = _MockHttpAdapter();

      final response = await _dioClient.dio.get('/protected-data');
      setState(() {
        _statusMessage = 'API Success: ${response.data}';
      });
    } on DioException catch (e) {
      setState(() {
        _statusMessage = 'API Failed: ${e.response?.statusCode} - ${e.message}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Dio Auth'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _statusMessage.startsWith('Logged in')
                    ? Icons.lock_open
                    : Icons.lock_outline,
                size: 80,
                color: _statusMessage.startsWith('Logged in')
                    ? Colors.green
                    : Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              if (_isLoading)
                const CircularProgressIndicator()
              else ...[
                ElevatedButton.icon(
                  onPressed: _login,
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _callProtectedApi,
                  icon: const Icon(Icons.security),
                  label: const Text('Call Protected API (Test Refresh)'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// A simple mock adapter to simulate 401 error on first call and 200 on retry
class _MockHttpAdapter implements HttpClientAdapter {
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final token = options.headers['Authorization'];

    if (token == null || !token.toString().contains('refreshed')) {
      // First call or token not refreshed -> return 401
      callCount++;
      return ResponseBody.fromString(
        '{"error": "Unauthorized"}',
        401,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    } else {
      // Token is refreshed -> return 200 success
      return ResponseBody.fromString(
        '{"data": "Secret protected information!"}',
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }
  }

  @override
  void close({bool force = false}) {}
}
