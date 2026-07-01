import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/logger/app_logger.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    final connected = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
    AppLogger.debug('Connectivity check: ${connected ? "Online" : "Offline"}');
    return connected;
  }

  Stream<bool> get connectivityStream =>
      _connectivity.onConnectivityChanged.map(
        (results) => results.any(
          (r) =>
              r == ConnectivityResult.mobile ||
              r == ConnectivityResult.wifi ||
              r == ConnectivityResult.ethernet,
        ),
      );
}
