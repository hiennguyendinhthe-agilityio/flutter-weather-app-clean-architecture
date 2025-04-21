import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_books_app/presentation/auth/service/auth_storage_service.dart';
import 'package:online_books_app/presentation/settings/controller/settings_controller.dart';
import 'package:online_books_app/presentation/settings/models/settings_model.dart';
import 'package:permission_handler/permission_handler.dart';

class MockAuthStorageService extends Mock implements AuthStorageService {}

class MockPermission extends Mock implements Permission {}

void main() {
  late SettingsController settingsController;
  late MockAuthStorageService mockAuthStorage;
  late MockPermission mockPermission;

  setUp(() {
    mockAuthStorage = MockAuthStorageService();
    mockPermission = MockPermission();

    settingsController = SettingsController(
      SettingsModel() as Rx<SettingsModel>,
    );
  });

  test('logOut should clear credentials and navigate to login screen',
      () async {
    when(() => mockAuthStorage.clearSavedCredentials())
        .thenAnswer((_) async => {});

    settingsController.logOut();

    verify(() => mockAuthStorage.clearSavedCredentials()).called(1);
    verify(() => Get.offAll(any())).called(1);

    verify(() => Get.snackbar(
          "Logged Out",
          "You have been logged out successfully.",
          backgroundColor: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.logout, color: Colors.white),
        )).called(1);
  });

  test(
      'requestNotificationPermission should show snackbar when permission is granted',
      () async {
    when(() => mockPermission.request())
        .thenAnswer((_) async => PermissionStatus.granted);

    await settingsController.requestNotificationPermission();

    verify(() => Get.snackbar(
          "Permission Granted",
          "You can now receive notifications.",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.notifications, color: Colors.white),
        )).called(1);
  });

  test(
      'requestNotificationPermission should show snackbar when permission is denied',
      () async {
    when(() => mockPermission.request())
        .thenAnswer((_) async => PermissionStatus.denied);

    await settingsController.requestNotificationPermission();

    verify(() => Get.snackbar(
          "Permission Denied",
          "You need to grant notification permission to receive notifications.",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.notifications_off, color: Colors.white),
        )).called(1);
  });

  test(
      'requestNotificationPermission should open app settings when permission is permanently denied',
      () async {
    when(() => mockPermission.request())
        .thenAnswer((_) async => PermissionStatus.permanentlyDenied);

    await settingsController.requestNotificationPermission();

    verify(() => openAppSettings()).called(1);
  });

  test('changeLanguage should update the locale to Vietnamese', () async {
    expect(settingsController.currentLanguage.value, 'English');

    settingsController.changeLanguage('vi');

    expect(settingsController.currentLanguage.value, 'vi');
  });
}
