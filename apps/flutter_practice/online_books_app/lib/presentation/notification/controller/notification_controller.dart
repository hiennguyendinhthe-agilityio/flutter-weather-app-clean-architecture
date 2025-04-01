import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/data/services/notification_service.dart';
import 'package:online_books_app/presentation/notification/detail_page.dart';

class NotificationController extends GetxController {
  RxString fcmToken = ''.obs;
  RxString notificationMessage = ''.obs;
  RxList<Map<String, String>> notifications = <Map<String, String>>[].obs;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    _requestPermission();
    _getToken();
    _setUpForegroundNotifications();
    _setUpBackgroundNotifications();
    _handleNotificationClicks();
  }

  void _handleNotificationClicks() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        Get.to(() =>
            DetailPage(notification: Map<String, String>.from(message.data)));
      }
    });
  }

  // Request permission to show notifications
  void _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  // Get FCM Token
  void _getToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      fcmToken.value = token;
      debugPrint('FCM Token: $token');
    } else {
      debugPrint('FCM token is null');
    }
  }

  // Handle foreground notifications
  void _setUpForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        debugPrint(
            'Message received in foreground: ${message.notification!.title}');
        notificationMessage.value = message.notification!.title ?? 'No Title';

        // Show local notification
        _notificationService.showNotification(
          message.notification!.title ?? 'No Title',
          message.notification!.body ?? 'No Body',
        );

        // Add the new notification to the list
        notifications.add({
          'title': message.notification!.title ?? 'No Title',
          'body': message.notification!.body ?? 'No Body',
          'post_id': message.data['post_id'] ?? 'No ID',
          'url': message.data['url'] ?? 'No URL',
        });
      }
    });
  }

  // Handle background notifications
  void _setUpBackgroundNotifications() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('Handling background message: ${message.messageId}');

    if (message.data.isNotEmpty) {
      Get.to(() =>
          DetailPage(notification: Map<String, String>.from(message.data)));
    }
  }
}
