import 'package:injectable/injectable.dart';

@singleton
class LoggerService {
  void log(String message) {
    print('[LOG] ${DateTime.now()}: $message');
  }

  void logInfo(String message) {
    print('[INFO] ${DateTime.now()}: $message');
  }

  void logError(String message) {
    print('[ERROR] ${DateTime.now()}: $message');
  }
}
