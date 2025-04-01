import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_books_app/core/controller_binder.dart';
import 'package:online_books_app/core/utils/logger.dart';
import 'package:online_books_app/presentation/my_app/my_app.dart';

void main() async {
  ControllerBinder.bindControllers();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}
