import 'package:json_annotation/json_annotation.dart';

part 'api_user.g.dart';

@JsonSerializable()
class ApiUser {
  final String id;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  final String name;
  final String avatar;
  final String email;

  const ApiUser({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.email,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) => _$ApiUserFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'ApiUser{id: $id, name: $name, email: $email}';
  }
}