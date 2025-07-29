// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiUser _$ApiUserFromJson(Map<String, dynamic> json) => ApiUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  avatar: json['avatar'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ApiUserToJson(ApiUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'avatar': instance.avatar,
  'phone': instance.phone,
  'address': instance.address,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    CreateUserRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$CreateUserRequestToJson(CreateUserRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'address': instance.address,
    };

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserRequest(
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'address': instance.address,
    };

MockLoginRequest _$MockLoginRequestFromJson(Map<String, dynamic> json) =>
    MockLoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$MockLoginRequestToJson(MockLoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

MockLoginResponse _$MockLoginResponseFromJson(Map<String, dynamic> json) =>
    MockLoginResponse(
      token: json['token'] as String,
      user: ApiUser.fromJson(json['user'] as Map<String, dynamic>),
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$MockLoginResponseToJson(MockLoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
      'expires_in': instance.expiresIn,
    };
