// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:online_books_app/data/network/failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    failure = _mapErrorToFailure(error) ??
        Failure(ResponseCode.DEFAULT, message: "Unknown error");
  }

  Failure? _mapErrorToFailure(dynamic error) {
    if (error is DioException) {
      return _handleError(error);
    }
    return _handleBadResponse(error);
  }
}

Failure _handleError(DioException error) {
  switch (error) {
    case DioException(type: DioExceptionType.connectionTimeout):
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioException(type: DioExceptionType.sendTimeout):
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioException(type: DioExceptionType.receiveTimeout):
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioException(
          type: DioExceptionType.badResponse,
          response: final response?
        )
        when response.statusCode != null && response.statusMessage != null:
      return Failure(response.statusCode ?? 0,
          message: response.data["message"] ?? "No error message provided.");
    default:
      return _handleBadResponse(error);
  }
}

_handleBadResponse(DioException error) {
  try {
    final code = error.response?.statusCode ?? ResponseCode.DEFAULT;
    switch (code) {
      case ResponseCode.UNAUTORISED:
        return DataSource.UNAUTORISED.getFailure();
      case ResponseCode.FORBIDDEN:
        return DataSource.FORBIDDEN.getFailure();
      case ResponseCode.NOT_FOUND:
        return DataSource.NOT_FOUND.getFailure();
      case ResponseCode.CONFLICT:
        return DataSource.CONFLICT.getFailure();
      case ResponseCode.LOGINFAIL:
        return DataSource.LOGINFAIL.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  } catch (e) {
    return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  CONFLICT,
  LOGINFAIL,
  DEFAULT
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(
          ResponseCode.SUCCESS,
          message: CustomMessageError.generalSuccess,
        );
      case DataSource.NO_CONTENT:
        return Failure(
          ResponseCode.NO_CONTENT,
          message: CustomMessageError.errorNoContent,
        );
      case DataSource.BAD_REQUEST:
        return Failure(
          ResponseCode.BAD_REQUEST,
          message: CustomMessageError.errorBadRequest,
        );
      case DataSource.FORBIDDEN:
        return Failure(
          ResponseCode.FORBIDDEN,
          message: CustomMessageError.errorForbidden,
        );
      case DataSource.UNAUTORISED:
        return Failure(
          ResponseCode.UNAUTORISED,
          message: CustomMessageError.errorUnauthorized,
        );
      case DataSource.NOT_FOUND:
        return Failure(
          ResponseCode.NOT_FOUND,
          message: CustomMessageError.errorNotFound,
        );
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          message: CustomMessageError.errorInternalServer,
        );
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
          ResponseCode.CONNECT_TIMEOUT,
          message: CustomMessageError.errorTimeout,
        );
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
          ResponseCode.RECIEVE_TIMEOUT,
          message: CustomMessageError.errorTimeout,
        );
      case DataSource.SEND_TIMEOUT:
        return Failure(
          ResponseCode.SEND_TIMEOUT,
          message: CustomMessageError.errorSendTimeout,
        );
      case DataSource.CACHE_ERROR:
        return Failure(
          ResponseCode.CACHE_ERROR,
          message: CustomMessageError.errorCache,
        );
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          message: CustomMessageError.errorNoInternetConnection,
        );
      case DataSource.CONFLICT:
        return Failure(
          ResponseCode.CONFLICT,
          message: CustomMessageError.errorConflictEmail,
        );
      case DataSource.LOGINFAIL:
        return Failure(
          ResponseCode.LOGINFAIL,
          message: CustomMessageError.authenticationFailure,
        );
      case DataSource.DEFAULT:
        return Failure(
          ResponseCode.DEFAULT,
          message: CustomMessageError.errorDefault,
        );
    }
  }
}

class CustomMessageError {
  static const String generalSuccess = "Success";
  static const String errorNoContent = "No content";
  static const String errorBadRequest = "Bad request";
  static const String errorForbidden = "Forbidden";
  static const String errorUnauthorized = "Unauthorized";
  static const String errorNotFound = "Not found";
  static const String errorInternalServer = "Internal server error";
  static const String errorTimeout = "Timeout";
  static const String errorSendTimeout = "Send timeout";
  static const String errorCache = "Cache error";
  static const String errorNoInternetConnection = "No internet connection";
  static const String errorConflictEmail = "Email already exists";
  static const String authenticationFailure = "Authentication failure";
  static const String errorDefault = "Something went wrong";
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found

  static const int CONFLICT = 409; // failure, API rejected request

  static const int LOGINFAIL = 501;

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}
