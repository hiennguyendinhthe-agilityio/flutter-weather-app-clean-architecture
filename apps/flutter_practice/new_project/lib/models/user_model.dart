import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// User Model for MockAPI
/// Represents a user in the application
/// Includes fields for user details and methods for JSON serialization
@JsonSerializable()
class ApiUser {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final String? address;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const ApiUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUserToJson(this);

  @override
  String toString() => 'ApiUser(id: $id, name: $name, email: $email)';
}

/// Create User Request for POST
@JsonSerializable()
class CreateUserRequest {
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final String? address;

  const CreateUserRequest({
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.address,
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);
}

/// Update User Request for PUT
@JsonSerializable()
class UpdateUserRequest {
  final String? name;
  final String? email;
  final String? avatar;
  final String? phone;
  final String? address;

  const UpdateUserRequest({
    this.name,
    this.email,
    this.avatar,
    this.phone,
    this.address,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}

/// Login Request (for demo - MockAPI doesn't have real auth)
@JsonSerializable()
class MockLoginRequest {
  final String email;
  final String password;

  const MockLoginRequest({required this.email, required this.password});

  factory MockLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$MockLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MockLoginRequestToJson(this);
}

/// Login Response (simulated)
@JsonSerializable()
class MockLoginResponse {
  final String token;
  final ApiUser user;
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  const MockLoginResponse({
    required this.token,
    required this.user,
    required this.expiresIn,
  });

  factory MockLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$MockLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MockLoginResponseToJson(this);
}
