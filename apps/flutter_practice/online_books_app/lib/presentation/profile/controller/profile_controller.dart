import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_books_app/core/app_export.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileController extends GetxController {
  ProfileController();

  final ImagePicker _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  Future<void> pickImage(ImageSource source) async {
    // Determine the required permission
    Permission requiredPermission;
    String permissionName; // Permission name for user messages

    if (source == ImageSource.camera) {
      requiredPermission = Permission.camera;
      permissionName = "camera";
    } else {
      // Use Permission.photos for both Android and iOS (recommended)
      // permission_handler handles specifics like READ_MEDIA_IMAGES on Android 13+
      requiredPermission = Permission.photos;
      permissionName = "photo library";
    }

    // 1. Check the current permission status
    PermissionStatus status = await requiredPermission.status;
    debugPrint(
        "Permission status for $permissionName: $status"); // Log status for debugging

    // 2. If denied (first time or previously denied), request it
    if (status.isDenied) {
      status = await requiredPermission.request();
      debugPrint(
          "Requested. New status for $permissionName: $status"); // Log new status
    }

    // 3. Handle based on the status after checking/requesting
    if (status.isGranted || status.isLimited) {
      // isLimited: Granted access to specific photos (iOS)
      // Permission granted -> Proceed with image picking
      try {
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          profileImage.value = File(pickedFile.path);
        } else {
          // User might have cancelled the picker
          debugPrint("User cancelled image picking.");
        }
      } catch (e) {
        debugPrint("Error picking image: $e");
        Get.snackbar(
          "Error",
          "Could not pick image. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      // Permission permanently denied or restricted (e.g., by parental controls)
      // -> Inform the user and guide them to settings
      Get.dialog(
        AlertDialog(
          title: const Text("Permission Denied"),
          content: Text(
              "You have permanently denied access to the $permissionName. Please go to App Settings to enable it."),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text("Open Settings"),
              onPressed: () {
                Get.back();
                openAppSettings();
              },
            ),
          ],
        ),
      );
    } else {
      // Handle other denied cases (isDenied after request)
      Get.dialog(
        AlertDialog(
          title: const Text("Permission Denied"),
          content: Text(
              "You need to grant access to the $permissionName to use this feature."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
  }
}
