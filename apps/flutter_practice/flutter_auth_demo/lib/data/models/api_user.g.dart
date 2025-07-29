// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiUser _$ApiUserFromJson(Map<String, dynamic> json) => ApiUser(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String,
  avatar: json['avatar'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$ApiUserToJson(ApiUser instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'name': instance.name,
  'avatar': instance.avatar,
  'email': instance.email,
};
