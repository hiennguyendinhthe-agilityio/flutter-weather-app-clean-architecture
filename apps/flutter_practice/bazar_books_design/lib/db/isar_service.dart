import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  Isar? _isarInstance;

  Future<Isar> get db async {
    if (_isarInstance == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isarInstance = await Isar.open(
        [
          ProductSchema,
          UserSchema,
        ],
        directory: dir.path,
      );
    }
    return _isarInstance!;
  }

  Future<void> saveUser(User user) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final existingUser =
          await isar.users.filter().emailEqualTo(user.email).findFirst();
      if (existingUser == null) {
        await isar.users.put(user);
      } else {
        existingUser.isLoggedIn = user.isLoggedIn;
        await isar.users.put(existingUser);
      }
    });
  }

  Future<User?> getLoggedInUser() async {
    final isar = await db;
    return await isar.users.filter().isLoggedInEqualTo(true).findFirst();
  }

  Future<void> logoutUser() async {
    final isar = await db;
    await isar.writeTxn(() async {
      final user =
          await isar.users.where().filter().isLoggedInEqualTo(true).findFirst();
      if (user != null) {
        user.isLoggedIn = false;
        await isar.users.put(user);
      }
    });
  }

  Future<void> deleteUserById(int userId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.users.delete(userId);
    });
  }

  Future<void> deleteAllUsers() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.users.clear();
    });
  }

  Future<void> closeIsar() async {
    await _isarInstance?.close();
    _isarInstance = null;
  }

  Future<User?> checkAccountFromApi(
    String email,
    String password,
  ) async {
    try {
      final response = await Dio().get(
        '${Constants.apiUrlUser}user',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      throw Exception('Error checking account from API: $e');
    }
  }

  Future<bool> isUserLoggedInFromIsar() async {
    final isar = await db;
    final user = await isar.users.filter().isLoggedInEqualTo(true).findFirst();
    return user != null;
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    try {
      final userFromApi = await checkAccountFromApi(
        email,
        password,
      );

      if (userFromApi != null) {
        final isLoggedIn = await isUserLoggedInFromIsar();

        if (!isLoggedIn) {
          userFromApi.isLoggedIn = true;
          await saveUser(userFromApi);
        }
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }
}
