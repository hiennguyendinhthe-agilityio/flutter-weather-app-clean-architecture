import 'package:bazar_books_app/di/di.dart';
import 'package:bazar_books_app/main_app/main_app.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedQuery.instance.configFlutter(
    observers: [BazQueryObserver()],
    config: QueryConfigFlutter(
      refetchOnConnection: true,
      refetchOnResume: true,
      cacheDuration: const Duration(minutes: 5),
      refetchDuration: const Duration(seconds: 5),
    ),
  );
  await initGetIt();

  runApp(
    DevicePreview(
      builder: (context) => const MainApp(),
    ),
  );
}
