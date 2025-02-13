import 'dart:convert';
import 'dart:developer';

import 'package:bazar_books_app/detail_page_example.dart';
import 'package:bazar_books_app/features/chat/chatscreen.dart';
import 'package:bazar_books_app/main.dart';
import 'package:bazar_books_app/oder_detail_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Request permission
    await _requestPermission();

    //  Setup Flutter Local Notifications
    await _setupMessageHandler();

    // Get FCM Token
    final token = await _messaging.getToken();
    log('FCM token: $token');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      log('Permission denied by user');

      _showPermissionDeniedDialog();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      log('Permission not determined');
      _showPermissionNotDeterminedDialog();
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('Permission granted: ${settings.authorizationStatus}');
    }
  }

  void _showPermissionDeniedDialog() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Notification Permission Denied'),
          content: const Text(
              'Please enable notifications in your device settings to stay updated.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showPermissionNotDeterminedDialog() {
    log('Permission not determined. Please decide in settings.');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          _handleNotificationClick(jsonDecode(details.payload!));
        }
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    navigateToDetail(data);
  }

  Future<void> showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final Map<String, dynamic> data = message.data;

    final String title = notification?.title ?? data['title'] ?? 'No Title';
    final String body = notification?.body ?? data['body'] ?? 'No Body';

    await _localNotifications.show(
      notification?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  Future<void> _setupMessageHandler() async {
    FirebaseMessaging.onMessage.listen(
      (messages) {
        showNotification(messages);
        log("📌 Title: ${messages.notification?.title}");
        log("📌 Body: ${messages.notification?.body}");
        log("📦 Data: ${messages.data}");
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      handleBackgroundMessage(initialMessage);
    }
  }

  void handleBackgroundMessage(RemoteMessage message) {
    final Map<String, dynamic> data = message.data;
    _handleNotificationClick(data);
  }

  void navigateToDetail(Map<String, dynamic> data,
      {RemoteNotification? notification}) {
    final notificationType = data['type'];

    switch (notificationType) {
      case 'order_update':
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(
              title: data['title'] ?? 'Order Update',
              body: data['body'] ?? 'Your order has been updated!',
              data: {
                'orderId': data['orderId'] ?? 'Unknown',
                'orderStatus': data['orderStatus'] ?? 'Pending',
              },
            ),
          ),
        );
        break;

      case 'new_message':
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              orderId: data['orderId'] ?? 'Unknown',
              userId: data['userId'] ?? 'Unknown',
            ),
          ),
        );
        break;

      default:
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => DetailPage(
              title: notification?.title ?? data['title'] ?? 'No title',
              body: notification?.body ?? data['body'] ?? 'No body',
              data: data,
            ),
          ),
        );
    }
  }
}
