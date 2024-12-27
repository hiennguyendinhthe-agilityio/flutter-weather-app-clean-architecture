import 'package:bazar_books_design/core/models/auth_model/api_user.dart';
import 'package:bazar_books_design/core/models/auth_model/isar_user.dart';

extension ApiUserToIsar on ApiUser {
  IsarUser toIsarUser() {
    return IsarUser(
      userId: userId,
      name: name,
      email: email,
      isLoggedIn: isLoggedIn,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
    );
  }
}

extension IsarUserToApi on IsarUser {
  ApiUser toApiUser() {
    return ApiUser(
      userId: userId,
      name: name,
      email: email,
      isLoggedIn: isLoggedIn,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
    );
  }
}
