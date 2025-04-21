import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/data/services/notification_service.dart';
import 'package:online_books_app/presentation/notification/detail_page.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('(Background) Handling background message: ${message.messageId}');
  debugPrint('(Background) Data: ${message.data}');

  final notificationService = NotificationService();
  await notificationService.initialize();

  final title = message.notification?.title ??
      message.data['title'] ??
      'New Notification';
  final body = message.notification?.body ??
      message.data['body'] ??
      'You have a new notification';
  debugPrint('(Background) Notification Title: $title');
  debugPrint('(Background) Notification Body: $body');

  await notificationService.showNotification(
    title,
    body,
    payload: jsonEncode({
      ...message.data,
      'title': title,
      'body': body,
    }),
  );
}

class NotificationController extends GetxController {
  RxString fcmToken = ''.obs;
  RxString notificationMessage = ''.obs;
  RxList<Map<String, String>> notifications = <Map<String, String>>[].obs;
  Rx<PermissionStatus> notificationPermissionStatus =
      PermissionStatus.denied.obs;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() async {
    super.onInit();
    await _notificationService.initialize();
    _checkInitialPermissionStatus();
    _setupNotificationHandlers();
    if (notificationPermissionStatus.value.isGranted) {
      _getToken();
    }
  }

  void _setupNotificationHandlers() {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('(Foreground) Message data: ${message.data}');
      debugPrint(
          '(Foreground) Message notification: ${message.notification?.title}');

      final title =
          message.notification?.title ?? message.data['title'] ?? 'Title';
      final body = message.notification?.body ?? message.data['body'] ?? 'Body';

      notificationMessage.value = title;

      try {
        debugPrint('Creating notification payload:');
        debugPrint('Original message data: ${message.data}');
        debugPrint('Title: $title');
        debugPrint('Body: $body');

        final payloadData = {
          ...message.data,
          'title': title,
          'body': body,
        };
        debugPrint('Final payload data: $payloadData');

        await _notificationService.showNotification(
          title,
          body,
          payload: jsonEncode(payloadData),
        );
      } catch (e) {
        debugPrint('Error showing notification: $e');
      }

      notifications.add({
        'title': title,
        'body': body,
        'post_id': message.data['post_id'] ?? 'N/A',
        'url': message.data['url'] ?? 'N/A',
      });
    });

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Notification click handler for both background and foreground
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification clicked to open app: ${message.messageId}');
      debugPrint('Data: ${message.data}');

      final Map<String, String> notificationData = message.data.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );

      if (notificationData.isNotEmpty) {
        // Use Get.offAll to clear the navigation stack and show the detail page
        Get.to(() => DetailPage(notification: notificationData));
      }
    });

    // Handle initial message when app is opened from terminated state
    _handleInitialMessage();
  }

  // Check the initial permission status
  void _checkInitialPermissionStatus() async {
    final status = await Permission.notification.status;
    notificationPermissionStatus.value = status;
    debugPrint('Initial notification permission status: $status');

    // For iOS, we need to request permission explicitly
    if (Platform.isIOS && status.isDenied) {
      final newStatus = await Permission.notification.request();
      notificationPermissionStatus.value = newStatus;
      debugPrint(
          'New notification permission status after request: $newStatus');

      if (newStatus.isGranted) {
        _getToken();
      }
    } else if (status.isGranted) {
      _getToken();
    }
  }

  // Request notification permission
  Future<void> checkAndRequestPermission(BuildContext context) async {
    debugPrint('Requesting notification permission...');
    final currentStatus = await Permission.notification.status;
    notificationPermissionStatus.value = currentStatus;
    debugPrint('Current notification permission status: $currentStatus');
    if (!context.mounted) return;

    if (currentStatus.isGranted) {
      if (!context.mounted) return;
      debugPrint('Notification permission already granted');
      _showSnackBar(context, 'Permission already granted');
      _getToken();
      return;
    }

    if (currentStatus.isPermanentlyDenied) {
      debugPrint('Notification permission permanently denied');
      _showOpenSettingsDialog(context);
      return;
    }

    final bool? userAgreed = await _showPrePermissionDialog(context);

    if (userAgreed == true) {
      debugPrint('User agreed to request notification permission');
      final statusAfterRequest = await Permission.notification.request();
      notificationPermissionStatus.value = statusAfterRequest;
      debugPrint(
          'Notification permission status after request: $statusAfterRequest');
      if (!context.mounted) return;

      if (statusAfterRequest.isGranted) {
        debugPrint('Notification permission granted');
        _showSnackBar(context, 'Permission granted');
        _getToken();
      } else if (statusAfterRequest.isPermanentlyDenied) {
        debugPrint('Notification permission denied');
        _showOpenSettingsDialog(context);
      } else {
        debugPrint('User denied the permission request');
        _showDeniedMessage(context);
      }
    } else {
      if (!context.mounted) return;
      debugPrint('User denied the permission request');
      _showDeniedMessage(context, fromPrePrompt: true);
    }
  }

  Future<bool?> _showPrePermissionDialog(BuildContext context) async {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Notification Permission',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'This app requires notification permission to show notifications. Do you want to grant it?',
                style: TextStyle(color: Colors.black87),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ));
  }

  void _showOpenSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Notification Permission Denied',
          style: TextStyle(
            color: Colors.red[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You have denied notification permission for this app. To enable it, please go to Settings > [Online Books App] > Notifications.',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            child: Text(
              'Later',
              style: TextStyle(color: Colors.grey[700]),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Open Settings',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeniedMessage(BuildContext context, {bool fromPrePrompt = false}) {
    final message = fromPrePrompt
        ? 'You have chosen not to enable notifications. You can enable them later in the app settings.'
        : 'You have denied notification permission. Please enable it in the app settings to receive notifications.';
    _showSnackBar(context, message);
  }

  void _showSnackBar(BuildContext context, String message) {
    final bool isSuccess = message.toLowerCase().contains('granted');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _getToken() async {
    if (!notificationPermissionStatus.value.isGranted) {
      debugPrint('Cannot get token, permission not granted.');
      fcmToken.value = '';
      return;
    }
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        fcmToken.value = token;
        debugPrint('FCM Token: $token');
      } else {
        fcmToken.value = '';
        debugPrint('FCM token is null even with permission.');
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      fcmToken.value = '';
    }
  }

  Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
          'App launched from terminated state by notification: ${initialMessage.messageId}');
      debugPrint('Data: ${initialMessage.data}');
      final Map<String, String> notificationData = initialMessage.data.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );
      if (notificationData.isNotEmpty) {
        // Use Get.offAll to clear the navigation stack and show the detail page
        Future.delayed(Duration(milliseconds: 500), () {
          Get.offAll(() => DetailPage(notification: notificationData));
        });
      }
    }
  }
}
