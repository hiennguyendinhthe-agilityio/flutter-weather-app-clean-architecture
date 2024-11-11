import 'package:bazar_books_design/core/core.dart';
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
      await isar.users.put(user);
    });
  }

  Future<bool> isUserLoggedIn() async {
    final isar = await db;
    final users =
        await isar.users.where().filter().isLoggedInEqualTo(true).findAll();
    return users.isNotEmpty;
  }

  Future<User?> getUser() async {
    final isar = await db;
    final users =
        await isar.users.where().filter().isLoggedInEqualTo(true).findAll();
    return users.isNotEmpty ? users.first : null;
  }

  Future<void> logoutDB() async {
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

  Future<void> closeIsar() async {
    await _isarInstance?.close();
    _isarInstance = null;
  }
}
