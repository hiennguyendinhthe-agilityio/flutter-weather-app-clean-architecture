import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:online_books_app/routes/app_routes.dart';
import 'package:path_provider/path_provider.dart';

part 'user.g.dart';

@Collection()
class User {
  Id? id;

  late String email;
  late DateTime loginTime;

  User({
    required this.email,
    required this.loginTime,
  });
}

class DatabaseService {
  Isar? _isarInstance;

  Future<Isar> get db async {
    if (_isarInstance == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isarInstance = await Isar.open(
        [UserSchema],
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

  Future<User?> getUser() async {
    final isar = await db;
    return await isar.users.count() == 0 ? null : await isar.users.get(0);
  }

  Future<void> deleteUser() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.users.clear();
    });
  }

  Future<void> checkLoginStatus() async {
    User? user = await getUser();

    if (user != null) {
      DateTime now = DateTime.now();
      Duration difference = now.difference(user.loginTime);

      if (difference.inDays <= 7) {
        Get.offAllNamed(AppRoutes.homeInitialPage);
      } else {
        Get.offAllNamed(AppRoutes.loginScreen);
      }
    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  Future<void> closeIsar() async {
    await _isarInstance?.close();
    _isarInstance = null;
  }
}
