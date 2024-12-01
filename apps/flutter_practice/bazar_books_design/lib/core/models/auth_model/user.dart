import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;

  late String? userId;
  late String? name;
  late String? email;
  late String? password;
  late bool isLoggedIn;
  late String? avatarUrl;
  late String? phoneNumber;

  User({
    this.userId,
    this.name,
    this.email,
    this.password,
    this.isLoggedIn = false,
    this.avatarUrl,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      isLoggedIn: json['isLoggedIn'] ?? false,
      avatarUrl: json['avatarUrl'],
      phoneNumber: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': name,
      'email': email,
      'password': password,
      'isLoggedIn': isLoggedIn,
      'avatarUrl': avatarUrl,
      'number': phoneNumber,
    };
  }
}
