import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:injectable/injectable.dart';

/// Service to manage Android Intents.
@singleton
class AndroidIntentService {
  /// Checks if the current platform is Android.
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Opens the main system Settings application.
  Future<void> openSettings() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(action: 'android.settings.SETTINGS');
    await intent.launch();
  }

  /// Opens the Wi-Fi settings screen.
  Future<void> openWifiSettings() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(action: 'android.settings.WIFI_SETTINGS');
    await intent.launch();
  }

  /// Opens the Bluetooth settings screen.
  Future<void> openBluetoothSettings() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(action: 'android.settings.BLUETOOTH_SETTINGS');
    await intent.launch();
  }

  /// Opens the Location settings screen.
  Future<void> openLocationSettings() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  /// Opens the settings screen for this specific application.
  Future<void> openAppSettings() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(
      action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
      data:
          'package:com.example.flutter_auth_demo', // Replace with the actual package name
    );
    await intent.launch();
  }

  /// Calls a phone number directly.
  Future<void> makePhoneCall(String phoneNumber) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.CALL',
      data: 'tel:$phoneNumber',
    );
    await intent.launch();
  }

  /// Opens the dialer with a pre-filled phone number.
  Future<void> openDialer(String phoneNumber) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.DIAL',
      data: 'tel:$phoneNumber',
    );
    await intent.launch();
  }

  /// Opens the default SMS app with a pre-filled recipient and message.
  Future<void> sendSMS(String phoneNumber, String message) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.SENDTO',
      data: 'smsto:$phoneNumber',
      arguments: {'sms_body': message},
    );
    await intent.launch();
  }

  /// Opens the default email client with pre-filled fields.
  Future<void> sendEmail({
    required String to,
    String? subject,
    String? body,
  }) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.SENDTO',
      data: 'mailto:$to',
      arguments: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    await intent.launch();
  }

  /// Opens a URL in the default web browser.
  Future<void> openUrl(String url) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: url,
    );
    await intent.launch();
  }

  /// Opens Google Maps to show a specific address.
  Future<void> openMaps(String address) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'geo:0,0?q=${Uri.encodeComponent(address)}',
    );
    await intent.launch();
  }

  /// Opens Google Maps to show specific coordinates.
  Future<void> openMapsWithCoordinates(
    double latitude,
    double longitude,
  ) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'geo:$latitude,$longitude',
    );
    await intent.launch();
  }

  /// Opens the default camera application.
  Future<void> openCamera() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(action: 'android.media.action.IMAGE_CAPTURE');
    await intent.launch();
  }

  /// Opens the gallery to pick an image.
  Future<void> openGallery() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(
      action: 'android.intent.action.PICK',
      type: 'image/*',
    );
    await intent.launch();
  }

  /// Opens the file manager to pick any file.
  Future<void> openFileManager() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(
      action: 'android.intent.action.GET_CONTENT',
      type: '*/*',
    );
    await intent.launch();
  }

  /// Shares a plain text string.
  Future<void> shareText(String text) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      type: 'text/plain',
      arguments: {'android.intent.extra.TEXT': text},
    );
    await intent.launch();
  }

  /// Shares a plain text string with a title (subject).
  Future<void> shareTextWithTitle(String text, String title) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      type: 'text/plain',
      arguments: {
        'android.intent.extra.TEXT': text,
        'android.intent.extra.SUBJECT': title,
      },
    );
    await intent.launch();
  }

  /// Opens a specific application by its package name.
  Future<void> openApp(String packageName) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: packageName,
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  /// Opens the Play Store to a specific app's page.
  Future<void> openPlayStore(String packageName) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'market://details?id=$packageName',
    );
    await intent.launch();
  }

  /// Performs a web search using the default search provider.
  Future<void> searchGoogle(String query) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.WEB_SEARCH',
      arguments: {'query': query},
    );
    await intent.launch();
  }

  /// Opens YouTube to a specific video.
  Future<void> openYouTube(String videoId) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'https://www.youtube.com/watch?v=$videoId',
    );
    await intent.launch();
  }

  /// Opens an application using a custom URL scheme.
  Future<void> openCustomScheme(String scheme) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: scheme,
    );
    await intent.launch();
  }

  /// Creates a new calendar event.
  Future<void> createCalendarEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
  }) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.INSERT',
      data: 'content://com.android.calendar/events',
      arguments: {
        'title': title,
        'beginTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
        if (description != null) 'description': description,
      },
    );
    await intent.launch();
  }

  /// Opens the contact picker to select a contact.
  Future<void> pickContact() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(
      action: 'android.intent.action.PICK',
      data: 'content://contacts/people',
    );
    await intent.launch();
  }

  /// Sets an alarm in the default clock app.
  Future<void> setAlarm(int hour, int minute, String message) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.SET_ALARM',
      arguments: {
        'android.intent.extra.alarm.HOUR': hour,
        'android.intent.extra.alarm.MINUTES': minute,
        'android.intent.extra.alarm.MESSAGE': message,
      },
    );
    await intent.launch();
  }

  /// Sets a timer in the default clock app.
  Future<void> setTimer(int seconds, String message) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'android.intent.action.SET_TIMER',
      arguments: {
        'android.intent.extra.alarm.LENGTH': seconds,
        'android.intent.extra.alarm.MESSAGE': message,
      },
    );
    await intent.launch();
  }

  /// Opens the default voice recorder application.
  Future<void> openVoiceRecorder() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(
      action: 'android.provider.MediaStore.RECORD_SOUND',
    );
    await intent.launch();
  }

  /// Opens the default music player application.
  Future<void> openMusicPlayer() async {
    if (!isAndroid) return;

    const intent = AndroidIntent(action: 'android.intent.action.MUSIC_PLAYER');
    await intent.launch();
  }

  /// Creates a shortcut on the home screen.
  Future<void> createShortcut({
    required String name,
    required String packageName,
    required String className,
  }) async {
    if (!isAndroid) return;

    final intent = AndroidIntent(
      action: 'com.android.launcher.action.INSTALL_SHORTCUT',
      arguments: {
        'android.intent.extra.shortcut.NAME': name,
        'android.intent.extra.shortcut.INTENT': {
          'action': 'android.intent.action.MAIN',
          'package': packageName,
          'class': className,
        },
      },
    );
    await intent.launch();
  }

  /// Checks if an intent can be launched.
  Future<bool> canLaunchIntent(AndroidIntent intent) async {
    if (!isAndroid) return false;

    try {
      await intent.launch();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Launches an intent with error handling.
  Future<bool> safelaunchIntent(AndroidIntent intent) async {
    if (!isAndroid) return false;

    try {
      await intent.launch();
      return true;
    } catch (e) {
      print('Error launching intent: $e');
      return false;
    }
  }
}
