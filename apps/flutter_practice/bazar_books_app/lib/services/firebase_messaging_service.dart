import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _incrementBadge();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await _resetBadge();
    });
  }

  static Future<void> _incrementBadge() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentBadge = prefs.getInt("badge_count") ?? 0;
    currentBadge++;

    await prefs.setInt("badge_count", currentBadge);
    FlutterAppBadger.updateBadgeCount(currentBadge);
  }

  static Future<void> _resetBadge() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("badge_count", 0);
    FlutterAppBadger.removeBadge();
  }
}
