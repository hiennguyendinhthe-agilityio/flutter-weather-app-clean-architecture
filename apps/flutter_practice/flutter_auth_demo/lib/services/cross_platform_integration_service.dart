import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'android_intent_service.dart';
import 'ios_integration_service.dart';

/// A service for managing cross-platform integrations.
@singleton
class CrossPlatformIntegrationService {
  CrossPlatformIntegrationService(this._androidService, this._iosService);

  final AndroidIntentService _androidService;
  final IOSIntegrationService _iosService;

  /// Gets the current platform as a string.
  String get currentPlatform {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isWeb => kIsWeb;

  /// Opens Settings (cross-platform).
  Future<void> openSettings() async {
    if (isAndroid) {
      await _androidService.openSettings();
    } else if (isIOS) {
      await _iosService.openSettings();
    }
  }

  /// Opens Wi-Fi Settings (cross-platform).
  Future<void> openWifiSettings() async {
    if (isAndroid) {
      await _androidService.openWifiSettings();
    } else if (isIOS) {
      await _iosService.openWifiSettings();
    }
  }

  /// Opens Bluetooth Settings (cross-platform).
  Future<void> openBluetoothSettings() async {
    if (isAndroid) {
      await _androidService.openBluetoothSettings();
    } else if (isIOS) {
      await _iosService.openBluetoothSettings();
    }
  }

  /// Opens Location Settings (cross-platform).
  Future<void> openLocationSettings() async {
    if (isAndroid) {
      await _androidService.openLocationSettings();
    } else if (isIOS) {
      await _iosService.openLocationSettings();
    }
  }

  /// Opens App Settings (cross-platform).
  Future<void> openAppSettings() async {
    if (isAndroid) {
      await _androidService.openAppSettings();
    } else if (isIOS) {
      await _iosService.openAppSettings();
    }
  }

  /// Makes a phone call (cross-platform).
  Future<void> makePhoneCall(String phoneNumber) async {
    if (isAndroid) {
      await _androidService.makePhoneCall(phoneNumber);
    } else if (isIOS) {
      await _iosService.makePhoneCall(phoneNumber);
    }
  }

  /// Opens the dialer (cross-platform).
  Future<void> openDialer(String phoneNumber) async {
    if (isAndroid) {
      await _androidService.openDialer(phoneNumber);
    } else if (isIOS) {
      await _iosService.makePhoneCall(
        phoneNumber,
      ); // iOS doesn't have a separate dialer intent.
    }
  }

  /// Sends an SMS (cross-platform).
  Future<void> sendSMS(String phoneNumber, String message) async {
    if (isAndroid) {
      await _androidService.sendSMS(phoneNumber, message);
    } else if (isIOS) {
      await _iosService.sendSMS(phoneNumber, message: message);
    }
  }

  /// Sends an email (cross-platform).
  Future<void> sendEmail({
    required String to,
    String? subject,
    String? body,
  }) async {
    if (isAndroid) {
      await _androidService.sendEmail(to: to, subject: subject, body: body);
    } else if (isIOS) {
      await _iosService.sendEmail(to: to, subject: subject, body: body);
    }
  }

  /// Opens Maps with an address (cross-platform).
  Future<void> openMaps(String address) async {
    if (isAndroid) {
      await _androidService.openMaps(address);
    } else if (isIOS) {
      await _iosService.openMaps(address);
    }
  }

  /// Opens Maps with coordinates (cross-platform).
  Future<void> openMapsWithCoordinates(
    double latitude,
    double longitude,
  ) async {
    if (isAndroid) {
      await _androidService.openMapsWithCoordinates(latitude, longitude);
    } else if (isIOS) {
      await _iosService.openMapsWithCoordinates(latitude, longitude);
    }
  }

  /// Opens a URL (cross-platform).
  Future<void> openURL(String url) async {
    if (isAndroid) {
      await _androidService.openUrl(url);
    } else if (isIOS) {
      await _iosService.openURL(url);
    }
  }

  /// Shares text (cross-platform).
  Future<void> shareText(String text) async {
    if (isAndroid) {
      await _androidService.shareText(text);
    } else if (isIOS) {
      await _iosService.shareText(text);
    }
  }

  /// Opens the Camera (cross-platform).
  Future<void> openCamera() async {
    if (isAndroid) {
      await _androidService.openCamera();
    } else if (isIOS) {
      await _iosService.openCamera();
    }
  }

  /// Opens the Gallery/Photos (cross-platform).
  Future<void> openGallery() async {
    if (isAndroid) {
      await _androidService.openGallery();
    } else if (isIOS) {
      await _iosService.openPhotos();
    }
  }

  /// Opens the Music Player (cross-platform).
  Future<void> openMusicPlayer() async {
    if (isAndroid) {
      await _androidService.openMusicPlayer();
    } else if (isIOS) {
      await _iosService.openMusic();
    }
  }

  /// Opens the Calendar (cross-platform).
  Future<void> openCalendar() async {
    if (isAndroid) {
      // Android doesn't have a direct calendar URL, uses an intent.
      print('Opening calendar on Android requires specific intent');
    } else if (isIOS) {
      await _iosService.openCalendar();
    }
  }

  /// Creates a Calendar Event (cross-platform).
  Future<void> createCalendarEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
  }) async {
    if (isAndroid) {
      await _androidService.createCalendarEvent(
        title: title,
        startTime: startTime,
        endTime: endTime,
        description: description,
      );
    } else if (isIOS) {
      await _iosService.createCalendarEvent(
        title: title,
        startDate: startTime,
        endDate: endTime,
      );
    }
  }

  /// Sets an Alarm (cross-platform).
  Future<void> setAlarm(int hour, int minute, String message) async {
    if (isAndroid) {
      await _androidService.setAlarm(hour, minute, message);
    } else if (isIOS) {
      // iOS doesn't support setting alarms via URL schemes.
      print('Setting alarm on iOS requires native implementation');
    }
  }

  /// Sets a Timer (cross-platform).
  Future<void> setTimer(int seconds, String message) async {
    if (isAndroid) {
      await _androidService.setTimer(seconds, message);
    } else if (isIOS) {
      await _iosService.setTimer(seconds);
    }
  }

  /// Opens the App Store/Play Store (cross-platform).
  Future<void> openAppStore(String appId) async {
    if (isAndroid) {
      await _androidService.openPlayStore(appId);
    } else if (isIOS) {
      await _iosService.openAppStore(appId);
    }
  }

  /// Social Media - Instagram (cross-platform).
  Future<void> openInstagram({String? username}) async {
    if (isAndroid) {
      final scheme = username != null
          ? 'https://instagram.com/$username'
          : 'https://instagram.com';
      await _androidService.openUrl(scheme);
    } else if (isIOS) {
      await _iosService.openInstagram(username: username);
    }
  }

  /// Social Media - YouTube (cross-platform).
  Future<void> openYouTube({String? videoId}) async {
    if (isAndroid) {
      if (videoId != null) {
        await _androidService.openYouTube(videoId);
      } else {
        await _androidService.openUrl('https://youtube.com');
      }
    } else if (isIOS) {
      await _iosService.openYouTube(videoId: videoId);
    }
  }

  /// Social Media - WhatsApp (cross-platform).
  Future<void> openWhatsApp({String? phoneNumber, String? message}) async {
    if (isAndroid) {
      String url = 'https://wa.me/';
      if (phoneNumber != null) {
        url += phoneNumber;
        if (message != null) {
          url += '?text=${Uri.encodeComponent(message)}';
        }
      }
      await _androidService.openUrl(url);
    } else if (isIOS) {
      await _iosService.openWhatsApp(
        phoneNumber: phoneNumber,
        message: message,
      );
    }
  }

  /// Gets platform-specific capabilities.
  Map<String, bool> getPlatformCapabilities() {
    return {
      'canMakePhoneCalls': isAndroid || isIOS,
      'canSendSMS': isAndroid || isIOS,
      'canSendEmail': isAndroid || isIOS,
      'canOpenMaps': isAndroid || isIOS,
      'canOpenSettings': isAndroid || isIOS,
      'canSetAlarms': isAndroid, // iOS requires native implementation
      'canSetTimers': isAndroid || isIOS,
      'canCreateCalendarEvents': isAndroid || isIOS,
      'canOpenCamera': isAndroid, // iOS requires image_picker
      'canOpenGallery': isAndroid || isIOS,
      'canShareText': isAndroid || isIOS,
      'canOpenAppStore': isAndroid || isIOS,
      'supportsFaceTime': isIOS,
      'supportsShortcuts': isIOS,
      'supportsIntents': isAndroid,
      'supportsURLSchemes': isIOS,
    };
  }

  /// Gets platform-specific limitations.
  List<String> getPlatformLimitations() {
    if (isAndroid) {
      return [
        'Requires specific permissions in AndroidManifest.xml',
        'Some intents may not work on all Android versions',
        'Custom ROMs may have different behaviors',
      ];
    } else if (isIOS) {
      return [
        'Limited by iOS security restrictions',
        'Some URL schemes may not work in newer iOS versions',
        'App Store review may reject apps using private URL schemes',
        'Camera/Photo access requires additional packages',
        'Calendar events require native iOS implementation',
      ];
    } else {
      return [
        'Web platform has limited system integration',
        'Most native features are not available',
        'Can only open URLs and basic web actions',
      ];
    }
  }

  /// Executes platform-specific batch operations.
  Future<List<bool>> executeBatchOperations(List<String> operations) async {
    final results = <bool>[];

    for (final operation in operations) {
      try {
        switch (operation) {
          case 'settings':
            await openSettings();
            break;
          case 'wifi':
            await openWifiSettings();
            break;
          case 'bluetooth':
            await openBluetoothSettings();
            break;
          case 'location':
            await openLocationSettings();
            break;
          case 'app_settings':
            await openAppSettings();
            break;
          default:
            throw 'Unknown operation: $operation';
        }
        results.add(true);
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        print('Operation $operation failed: $e');
        results.add(false);
      }
    }

    return results;
  }
}
