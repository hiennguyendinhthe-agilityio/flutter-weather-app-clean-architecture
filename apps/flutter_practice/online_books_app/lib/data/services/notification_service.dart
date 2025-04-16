import 'dart:convert';
import 'dart:core';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/notification/detail_page.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
      'Notification tapped in background: ${notificationResponse.payload}');
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Request notification permission for iOS
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      debugPrint('iOS notification permission request result: $result');
    }

    await _createNotificationChannel();
    _isInitialized = true;
    debugPrint('Notification Service Initialized');
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel chanel = AndroidNotificationChannel(
      'online-books-app',
      'online books app',
      description: 'your_channel_description',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(chanel);
  }

  Future<void> showNotification(String title, String body,
      {String? payload}) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      bool isEnabled = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      if (!isEnabled) {
        debugPrint('Cannot show local notification, permissions denied.');
        return;
      }

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'online-books-app',
        'online books app',
        channelDescription: 'your_channel_description',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
        playSound: true,
        enableVibration: true,
      );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidNotificationDetails, iOS: darwinNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
      debugPrint('Local notification shown successfully.');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    debugPrint(
        'Local notification tapped (foreground/background): Payload: $payload');
    if (payload != null && payload.isNotEmpty) {
      try {
        debugPrint("Processing payload for navigation...");
        // Parse the payload string back to Map
        final Map<String, String> notificationData = {};
        final payloadMap = Map<String, dynamic>.from(jsonDecode(payload));
        payloadMap.forEach((key, value) {
          notificationData[key] = value.toString();
        });

        // Ensure title and body are included
        if (!notificationData.containsKey('title')) {
          notificationData['title'] = 'No Title';
        }
        if (!notificationData.containsKey('body')) {
          notificationData['body'] = 'No Body';
        }

        if (notificationData.isNotEmpty) {
          // Use Get.to to add DetailPage to the navigation stack
          Get.to(() => DetailPage(notification: notificationData));
        }
      } catch (e) {
        debugPrint('Error decoding or handling payload: $e');
      }
    }
  }
}
