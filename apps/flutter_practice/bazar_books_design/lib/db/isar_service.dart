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

  Future<bool> isLoggedIn() async {
    final isar = await db;
    final user = await isar.users.get(0);
    return user != null && user.isLoggedIn;
  }

  Future<User?> getUser() async {
    final isar = await db;
    return await isar.users.get(0);
  }

  Future<void> logout() async {
    final isar = await db;
    await isar.writeTxn(() async {
      final user = await isar.users.get(0);
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
