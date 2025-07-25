import 'package:injectable/injectable.dart';

import 'logger_service.dart';

@injectable
class UserService {
  final LoggerService _loggerService;
  final String _userId;

  UserService(this._loggerService)
    : _userId = DateTime.now().millisecondsSinceEpoch.toString() {
    _loggerService.log('[UserService] New instance created with ID: $_userId');
  }

  String get userId => _userId;

  String getCurrentUser() {
    _loggerService.logInfo('Getting current user: $_userId');
    return 'User_$_userId';
  }

  void logout() {
    _loggerService.logInfo('User $_userId logged out');
  }
}
