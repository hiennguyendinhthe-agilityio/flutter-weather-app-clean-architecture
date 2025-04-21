import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/auth/login/login_screen.dart';
import 'package:online_books_app/presentation/auth/service/auth_storage_service.dart';
import 'package:online_books_app/presentation/settings/models/settings_model.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsController extends GetxController {
  SettingsController(this.settingsModelObj);

  Rx<SettingsModel> settingsModelObj;
  final AuthStorageService _authStorage = AuthStorageService();

  Rx<bool> isSelectedSwitch = false.obs;
  Rx<bool> isSelectedSwitch1 = false.obs;
  Rx<bool> isSelectedSwitch2 = false.obs;

  RxString currentLanguage = 'English'.obs;

  void changeLanguage(String languageCode) {
    final locale = _getLocaleFromLanguageCode(languageCode);
    Get.updateLocale(locale);
  }

  Locale _getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'en':
        return Locale('en', 'US');
      case 'vi':
        return Locale('vi', 'VN');
      default:
        return Locale('en', 'US');
    }
  }

  void logOut() async {
    // Clear saved credentials
    await _authStorage.clearSavedCredentials();

    Get.offAll(() => LoginScreen());

    Get.snackbar(
      "Logged Out",
      "You have been logged out successfully.",
      backgroundColor: Colors.blue,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      icon: Icon(Icons.logout, color: Colors.white),
    );
  }

  Future<void> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();

      if (status.isGranted) {
        Get.snackbar(
          "Permission Granted",
          "You can now receive notifications.",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.notifications, color: Colors.white),
        );
      } else {
        Get.snackbar(
          "Permission Denied",
          "You need to grant notification permission to receive notifications.",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.notifications_off, color: Colors.white),
        );

        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    } catch (e) {
      debugPrint("Error: $e");

      Get.snackbar(
        "Error",
        "There was an error requesting notification permissions.",
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
