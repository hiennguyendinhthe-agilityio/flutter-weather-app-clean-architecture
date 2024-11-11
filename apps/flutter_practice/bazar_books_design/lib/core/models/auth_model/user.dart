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

  User({
    this.userId,
    this.name,
    this.email,
    this.password,
    this.isLoggedIn = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': name,
      'email': email,
      'password': password,
      'isLoggedIn': isLoggedIn,
    };
  }
}
