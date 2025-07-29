// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  error: json['error'] as String?,
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'error': instance.error,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
      'expires_in': instance.expiresIn,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'full_name': instance.fullName,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
};

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
  code: json['code'] as String,
  message: json['message'] as String,
  details: json['details'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'details': instance.details,
};
