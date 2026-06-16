sealed class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection.',
    super.statusCode,
    super.originalError,
  });
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired. Please login again.',
    super.statusCode = 401,
    super.originalError,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.statusCode = 404,
    super.originalError,
  });
}

class ParseException extends AppException {
  const ParseException({
    super.message = 'Cannot read data from server.',
    super.statusCode,
    super.originalError,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Failed to load local data.',
    super.statusCode,
    super.originalError,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Unknown error.',
    super.statusCode,
    super.originalError,
  });
}
