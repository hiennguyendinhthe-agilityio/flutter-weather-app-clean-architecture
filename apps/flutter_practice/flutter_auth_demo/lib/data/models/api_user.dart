import 'package:json_annotation/json_annotation.dart';

part 'api_user.g.dart';

@JsonSerializable()
class ApiUser {
  const ApiUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatar = '',
    this.createdAt,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);
  final String id;
  final String name;
  final String email;
  @JsonKey(defaultValue: '')
  final String avatar;

  // Optional fields from MockAPI that we don't need for auth
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DateTime? createdAt;

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
