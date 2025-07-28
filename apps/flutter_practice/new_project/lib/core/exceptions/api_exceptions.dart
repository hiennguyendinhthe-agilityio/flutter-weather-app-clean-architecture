/// Base API Exception
class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const ApiException({
    required this.message,
    this.code,
    this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message';
}

/// Network related exceptions
class NetworkException extends ApiException {
  const NetworkException({
    required super.message,
    super.code = 'NETWORK_ERROR',
  });
}

/// Server error exceptions (5xx)
class ServerException extends ApiException {
  const ServerException({
    required super.message,
    super.code = 'SERVER_ERROR',
    super.statusCode,
  });
}

/// Client error exceptions (4xx)
class ClientException extends ApiException {
  const ClientException({
    required super.message,
    super.code = 'CLIENT_ERROR',
    super.statusCode,
  });
}

/// Authentication exceptions (401)
class UnauthorizedException extends ClientException {
  const UnauthorizedException({
    super.message = 'Unauthorized - Invalid credentials',
    super.code = 'UNAUTHORIZED',
    super.statusCode = 401,
  });
}

/// Forbidden exceptions (403)
class ForbiddenException extends ClientException {
  const ForbiddenException({
    super.message = 'Forbidden - Access denied',
    super.code = 'FORBIDDEN',
    super.statusCode = 403,
  });
}

/// Not found exceptions (404)
class NotFoundException extends ClientException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.code = 'NOT_FOUND',
    super.statusCode = 404,
  });
}

/// Validation exceptions (422)
class ValidationException extends ClientException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation failed',
    super.code = 'VALIDATION_ERROR',
    super.statusCode = 422,
    this.errors,
  });
}

/// Timeout exceptions
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timeout',
    super.code = 'TIMEOUT',
  });
}

/// Parse/Serialization exceptions
class ParseException extends ApiException {
  const ParseException({
    super.message = 'Failed to parse response',
    super.code = 'PARSE_ERROR',
  });
}