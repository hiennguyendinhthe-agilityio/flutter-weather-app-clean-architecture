import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/core/models/auth_model/isar_user.dart';
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
          IsarUserSchema,
        ],
        directory: dir.path,
      );
    }
    return _isarInstance!;
  }

  Future<void> saveUser(IsarUser user) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final existingUser =
          await isar.isarUsers.filter().emailEqualTo(user.email).findFirst();
      if (existingUser == null) {
        await isar.isarUsers.put(user);
      } else {
        existingUser.isLoggedIn = user.isLoggedIn;
        await isar.isarUsers.put(existingUser);
      }
    });
  }

  Future<IsarUser?> getLoggedInUser() async {
    final isar = await db;
    return await isar.isarUsers.filter().isLoggedInEqualTo(true).findFirst();
  }

  Future<void> logoutUser() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarUsers.clear();
    });
  }

  Future<void> deleteUserById(int userId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarUsers.delete(userId);
    });
  }

  Future<void> deleteAllUsers() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarUsers.clear();
    });
  }

  Future<void> closeIsar() async {
    await _isarInstance?.close();
    _isarInstance = null;
  }
}
