/// Base exception class for all application exceptions
abstract class AppException implements Exception {
  const AppException(this.message, [this.code]);
  final String message;
  final String? code;

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when network operations fail
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when API operations fail
class ApiException extends AppException {
  const ApiException(super.message, [super.code, this.statusCode]);
  final int? statusCode;

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException(super.message, [super.code]);

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when storage operations fail
class StorageException extends AppException {
  const StorageException(super.message, [super.code]);

  @override
  String toString() => 'StorageException: $message';
}
