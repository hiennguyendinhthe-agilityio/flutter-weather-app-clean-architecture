import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String token;
  final String? refreshToken;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.refreshToken,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    token,
    refreshToken,
    avatarUrl,
  ];
}

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.token,
    required super.refreshToken,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'refreshToken': refreshToken,
      'avatarUrl': avatarUrl,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? token,
    String? refreshToken,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
