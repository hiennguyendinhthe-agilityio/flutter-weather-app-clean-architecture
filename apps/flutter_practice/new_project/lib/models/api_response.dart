import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic API Response wrapper
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// Success response factory
  factory ApiResponse.success({
    required String message,
    T? data,
  }) =>
      ApiResponse(
        success: true,
        message: message,
        data: data,
      );

  /// Error response factory
  factory ApiResponse.error({
    required String message,
    String? error,
  }) =>
      ApiResponse(
        success: false,
        message: message,
        error: error,
      );
}

/// Login Request Model
@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Login Response Model
@JsonSerializable()
class LoginResponse {
  final String token;
  final UserData user;
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  const LoginResponse({
    required this.token,
    required this.user,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// User Data Model
@JsonSerializable()
class UserData {
  final String id;
  final String username;
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.isActive,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

/// API Error Model
@JsonSerializable()
class ApiError {
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}