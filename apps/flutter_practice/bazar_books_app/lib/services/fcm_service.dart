import 'package:bazar_books_app/example_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _requestPermission();
    await _setupLocalNotifications();

    FirebaseMessaging.onMessage.listen(_showNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageNavigation);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageNavigation(initialMessage);
    }
    final token = await _messaging.getToken();
    print('FCM token: $token');
  }

  Future<void> _requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('Notification permission denied');
    }
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final Map<String, dynamic> data =
              Map<String, dynamic>.from(details.payload! as Map);
          _navigateToPage(data);
        }
      },
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    await _localNotifications.show(
      notification.hashCode,
      notification?.title ?? data['title'] ?? 'No Title',
      notification?.body ?? data['body'] ?? 'No Body',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: data.toString(),
    );
  }

  void _handleMessageNavigation(RemoteMessage message) {
    if (navigatorKey.currentState != null) {
      _navigateToPage(message.data);
    }
  }

  void _navigateToPage(Map<String, dynamic> data) {
    final type = data['type'];

    switch (type) {
      case 'order_update':
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) =>
                OrderDetailPage(orderId: data['orderId'] ?? 'No ID'),
          ),
        );
        break;
      case 'new_message':
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ChatPage(userId: data['userId'] ?? 'No ID'),
          ),
        );
        break;
      case 'general':
      default:
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => GeneralDetailPage(
                title: data['title'] ?? 'No Title',
                body: data['body'] ?? 'No Body'),
          ),
        );
    }
  }
}
