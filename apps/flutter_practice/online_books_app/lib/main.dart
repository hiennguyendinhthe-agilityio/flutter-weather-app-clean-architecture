import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_books_app/core/controller_binder.dart';
import 'package:online_books_app/core/utils/logger.dart';
import 'package:online_books_app/core/utils/permissions_util.dart';
import 'package:online_books_app/data/services/notification_service.dart';
import 'package:online_books_app/presentation/my_app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  ControllerBinder.bindControllers();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);

  final permissionsUtil = PermissionsUtil();

  await permissionsUtil.requestPermissions();
  final notificationService = NotificationService();
  await notificationService.initialize();
  runApp(const MyApp());
}
