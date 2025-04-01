import 'dart:io';

import 'package:bazar_books_app/di/di.dart';
import 'package:bazar_books_app/main_app/main_app.dart';
import 'package:bazar_books_app/services/firebase_messaging_service.dart';
import 'package:bazar_books_app/services/notification_service.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final permissionsUtil = PermissionsUtil();
  await permissionsUtil.requestPermissions();
  CachedQuery.instance.configFlutter(
    observers: [
      BazQueryObserver(),
      QueryLoggingObserver(colors: !Platform.isIOS),
    ],
    config: QueryConfigFlutter(
      refetchOnConnection: true,
      refetchOnResume: true,
      cacheDuration: const Duration(minutes: 5),
      refetchDuration: const Duration(seconds: 5),
    ),
  );

  await initGetIt();

  await NotificationService.instance.initialize();

  await FirebaseMessagingService.initialize();

  runApp(
    DevicePreview(
      builder: (context) => const MainApp(),
    ),
  );
}
