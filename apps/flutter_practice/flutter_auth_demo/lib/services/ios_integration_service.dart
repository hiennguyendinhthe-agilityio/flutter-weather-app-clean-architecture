import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

/// A service to manage iOS-specific integrations.
@singleton
class IOSIntegrationService {
  /// Checks if the current platform is iOS.
  bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Opens the main Settings app.
  Future<void> openSettings() async {
    if (!isIOS) return;
    // Using AppSettingsType.settings for clarity.
    await AppSettings.openAppSettings(type: AppSettingsType.settings);
  }

  /// Opens the Wi-Fi settings.
  Future<void> openWifiSettings() async {
    if (!isIOS) return;
    // Using the app_settings package instead of an unstable URL scheme.
    await AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }

  /// Opens the Bluetooth settings.
  Future<void> openBluetoothSettings() async {
    if (!isIOS) return;
    await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
  }

  /// Opens the Location Services settings.
  Future<void> openLocationSettings() async {
    if (!isIOS) return;
    await AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  /// Opens the Notification settings.
  Future<void> openNotificationSettings() async {
    if (!isIOS) return;
    await AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  /// Opens the app-specific settings page.
  Future<void> openAppSettings() async {
    if (!isIOS) return;

    await AppSettings.openAppSettings();
  }

  /// Initiates a phone call.
  Future<void> makePhoneCall(String phoneNumber) async {
    if (!isIOS) return;

    final url = 'tel:$phoneNumber';
    await _launchURL(url);
  }

  /// Sends an SMS message.
  Future<void> sendSMS(String phoneNumber, {String? message}) async {
    if (!isIOS) return;

    String url = 'sms:$phoneNumber';
    if (message != null && message.isNotEmpty) {
      url +=
          '&body=${Uri.encodeComponent(message)}'; // Note: iOS sms scheme is simple, might not support body.
    }
    await _launchURL(url);
  }

  /// Composes an email.
  Future<void> sendEmail({
    required String to,
    String? subject,
    String? body,
  }) async {
    if (!isIOS) return;

    final String url = 'mailto:$to';
    final queryParameters = <String, String>{};

    if (subject != null) {
      queryParameters['subject'] = subject;
    }
    if (body != null) {
      queryParameters['body'] = body;
    }

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    await _launchURL(uri.toString());
  }

  /// Opens Apple Maps with a specific address.
  Future<void> openMaps(String address) async {
    if (!isIOS) return;

    final encodedAddress = Uri.encodeComponent(address);
    await _launchURL('maps://?q=$encodedAddress');
  }

  /// Opens Apple Maps with specific coordinates.
  Future<void> openMapsWithCoordinates(
    double latitude,
    double longitude,
  ) async {
    if (!isIOS) return;

    await _launchURL('maps://?ll=$latitude,$longitude');
  }

  /// Opens Apple Maps with directions.
  Future<void> openMapsDirections({
    required String destination,
    String? source,
  }) async {
    if (!isIOS) return;

    String url = 'maps://?daddr=${Uri.encodeComponent(destination)}';
    if (source != null) {
      url += '&saddr=${Uri.encodeComponent(source)}';
    }
    await _launchURL(url);
  }

  /// Opens the App Store to a specific app page.
  Future<void> openAppStore(String appId) async {
    if (!isIOS) return;

    await _launchURL('itms-apps://apps.apple.com/app/id$appId');
  }

  /// Opens a URL in the default browser (Safari).
  Future<void> openURL(String url) async {
    if (!isIOS) return;

    await _launchURL(url);
  }

  /// Shares text using the native share sheet.
  Future<void> shareText(String text) async {
    if (!isIOS) return;

    try {
      await Clipboard.setData(ClipboardData(text: text));
      // iOS doesn't have a direct share intent like Android.
      // This is a workaround. For a real share sheet, use the `share_plus` package.
    } catch (e) {
      print('Error sharing text: $e');
    }
  }

  /// Opens FaceTime for a video call.
  Future<void> openFaceTime(String contact) async {
    if (!isIOS) return;

    await _launchURL('facetime://$contact');
  }

  /// Opens FaceTime for an audio call.
  Future<void> openFaceTimeAudio(String contact) async {
    if (!isIOS) return;

    await _launchURL('facetime-audio://$contact');
  }

  /// Opens the Calendar app.
  Future<void> openCalendar() async {
    if (!isIOS) return;

    await _launchURL('calshow://');
  }

  /// Creates a new calendar event (requires native implementation).
  Future<void> createCalendarEvent({
    required String title,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (!isIOS) return;

    // iOS does not support creating events directly via URL schemes.
    // Requires using the EventKit framework through a platform channel.
    await _createEventWithPlatformChannel(title, startDate, endDate);
  }

  /// Opens the Contacts app.
  Future<void> openContacts() async {
    if (!isIOS) return;

    await _launchURL('contacts://');
  }

  /// Opens the Photos app.
  Future<void> openPhotos() async {
    if (!isIOS) return;

    await _launchURL('photos-redirect://');
  }

  /// Opens the Camera.
  Future<void> openCamera() async {
    if (!isIOS) return;

    // iOS does not have a direct camera URL scheme.
    // Requires using the `image_picker` or `camera` package.
    print('Camera opening requires image_picker package on iOS');
  }

  /// Opens the Music app.
  Future<void> openMusic() async {
    if (!isIOS) return;

    await _launchURL('music://');
  }

  /// Opens the Podcasts app.
  Future<void> openPodcasts() async {
    if (!isIOS) return;

    await _launchURL('podcasts://');
  }

  /// Opens the Voice Memos app.
  Future<void> openVoiceMemos() async {
    if (!isIOS) return;

    await _launchURL('voicememos://');
  }

  /// Opens the Clock app.
  Future<void> openClock() async {
    if (!isIOS) return;

    await _launchURL('clock-worldclock://');
  }

  /// Sets a timer in the Clock app.
  Future<void> setTimer(int seconds) async {
    if (!isIOS) return;

    await _launchURL('clock-timer://timer?duration=$seconds');
  }

  /// Opens the Weather app.
  Future<void> openWeather() async {
    if (!isIOS) return;

    await _launchURL('weather://');
  }

  /// Opens the Health app.
  Future<void> openHealth() async {
    if (!isIOS) return;

    await _launchURL('x-apple-health://');
  }

  /// Opens the Wallet app.
  Future<void> openWallet() async {
    if (!isIOS) return;

    await _launchURL('shoebox://');
  }

  /// Opens the Find My app.
  Future<void> openFindMy() async {
    if (!isIOS) return;

    await _launchURL('findmy://');
  }

  /// Opens the Shortcuts app.
  Future<void> openShortcuts() async {
    if (!isIOS) return;

    await _launchURL('shortcuts://');
  }

  /// Runs a specific Shortcut.
  Future<void> runShortcut(String shortcutName) async {
    if (!isIOS) return;

    final encodedName = Uri.encodeComponent(shortcutName);
    await _launchURL('shortcuts://run-shortcut?name=$encodedName');
  }

  /// Opens a specific section in the Settings app.
  Future<void> openSpecificSettings(String settingsPath) async {
    if (!isIOS) return;

    await _launchURL('App-Prefs:$settingsPath');
  }

  // A map of common settings paths on iOS.
  static const Map<String, String> commonSettingsPaths = {
    'General': 'General',
    'Display & Brightness': 'DISPLAY',
    'Sounds & Haptics': 'Sounds',
    'Siri & Search': 'SIRI',
    'Face ID & Passcode': 'PASSCODE',
    'Touch ID & Passcode': 'TOUCHID_PASSCODE',
    'Emergency SOS': 'EMERGENCY_SOS',
    'Battery': 'BATTERY_USAGE',
    'Privacy & Security': 'Privacy',
    'Screen Time': 'SCREEN_TIME',
    'Accessibility': 'ACCESSIBILITY',
    'Control Center': 'ControlCenter',
    'Do Not Disturb': 'DO_NOT_DISTURB',
    'Keyboard': 'General&path=Keyboard',
    'Language & Region': 'General&path=INTERNATIONAL',
    'VPN': 'VPN',
    'Personal Hotspot': 'INTERNET_TETHERING',
    'Cellular': 'MOBILE_DATA_SETTINGS_ID',
  };

  /// Opens an app using a custom URL scheme.
  Future<void> openCustomScheme(String scheme) async {
    if (!isIOS) return;

    await _launchURL(scheme);
  }

  /// Checks if a URL scheme can be launched.
  Future<bool> canLaunchScheme(String scheme) async {
    if (!isIOS) return false;

    try {
      final uri = Uri.parse(scheme);
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// A helper method to launch a URL.
  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL $url: $e');
      rethrow;
    }
  }

  /// A platform channel to create a calendar event (requires native iOS code).
  Future<void> _createEventWithPlatformChannel(
    String title,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    const platform = MethodChannel('ios_integration/calendar');

    try {
      await platform.invokeMethod('createEvent', {
        'title': title,
        'startDate': startDate?.millisecondsSinceEpoch,
        'endDate': endDate?.millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error creating calendar event: $e');
    }
  }

  /// Executes a batch of operations with error handling.
  Future<List<bool>> executeBatchOperations(
    List<Future<void> Function()> operations,
  ) async {
    if (!isIOS) return List.filled(operations.length, false);

    final results = <bool>[];

    for (final operation in operations) {
      try {
        await operation();
        results.add(true);
        // A small delay between operations to ensure they are processed.
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        print('Operation failed: $e');
        results.add(false);
      }
    }

    return results;
  }

  /// Launches an operation with a specified timeout.
  Future<bool> launchWithTimeout(
    Future<void> Function() operation, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (!isIOS) return false;

    try {
      await operation().timeout(timeout);
      return true;
    } catch (e) {
      print('Operation failed or timed out: $e');
      return false;
    }
  }

  /// Social media integrations.
  Future<void> openInstagram({String? username}) async {
    if (!isIOS) return;

    String url = 'instagram://';
    if (username != null) {
      url += 'user?username=$username';
    }

    try {
      await _launchURL(url);
    } catch (e) {
      // Fallback to web if the app is not installed.
      final webUrl = username != null
          ? 'https://instagram.com/$username'
          : 'https://instagram.com';
      await _launchURL(webUrl);
    }
  }

  Future<void> openTwitter({String? username}) async {
    if (!isIOS) return;

    String url = 'twitter://';
    if (username != null) {
      url += 'user?screen_name=$username';
    }

    try {
      await _launchURL(url);
    } catch (e) {
      // Fallback to web if the app is not installed.
      final webUrl = username != null
          ? 'https://twitter.com/$username'
          : 'https://twitter.com';
      await _launchURL(webUrl);
    }
  }

  Future<void> openYouTube({String? videoId, String? channelId}) async {
    if (!isIOS) return;

    String url = 'youtube://';
    if (videoId != null) {
      url += 'watch?v=$videoId';
    } else if (channelId != null) {
      url += 'channel/$channelId';
    }

    try {
      await _launchURL(url);
    } catch (e) {
      // Fallback to web if the app is not installed.
      String webUrl = 'https://youtube.com';
      if (videoId != null) {
        webUrl += '/watch?v=$videoId';
      } else if (channelId != null) {
        webUrl += '/channel/$channelId';
      }
      await _launchURL(webUrl);
    }
  }

  Future<void> openWhatsApp({String? phoneNumber, String? message}) async {
    if (!isIOS) return;

    String url = 'whatsapp://';
    if (phoneNumber != null) {
      url += 'send?phone=$phoneNumber';
      if (message != null) {
        url += '&text=${Uri.encodeComponent(message)}';
      }
    }

    try {
      await _launchURL(url);
    } catch (e) {
      // Fallback to App Store if WhatsApp is not installed.
      // App Store ID for WhatsApp is 310633997.
      await openAppStore('310633997');
    }
  }

  Future<void> openTelegram({String? username}) async {
    if (!isIOS) return;

    String url = 'tg://';
    if (username != null) {
      url += 'resolve?domain=$username';
    }

    await _launchURL(url);
  }
}
