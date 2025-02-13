import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProfileRepository {
  Database? _database;
  final String _dbPath = 'profile.db';

  // Private function to initialize the database.
  Future<void> _initializeDatabase() async {
    final path = join(await getDatabasesPath(), _dbPath);

    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE profile(id INTEGER PRIMARY KEY AUTOINCREMENT, avatar_path TEXT)',
      );
    });
  }

  // Function to save the avatar image path to the database.
  Future<void> saveAvatar(File avatar) async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final avatarPath = avatar.path;

    await _database!.insert(
      'profile',
      {'avatar_path': avatarPath},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function to retrieve the avatar image file from the database.
  Future<File?> getAvatar() async {
    if (_database == null) {
      await _initializeDatabase();
    }

    final List<Map<String, dynamic>> maps = await _database!.query('profile');

    if (maps.isNotEmpty) {
      final String avatarPath = maps[0]['avatar_path'];

      return File(avatarPath);
    }

    return null;
  }
}
