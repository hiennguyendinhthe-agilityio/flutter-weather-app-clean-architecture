import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionsUtil {
  Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();

    if (status.isGranted) {
      log('Permission ${permission.toString()} granted');
      return true;
    } else if (status.isPermanentlyDenied) {
      log('Permission ${permission.toString()} permanently denied');
      return false;
    } else {
      log('Permission ${permission.toString()} denied');
      return false;
    }
  }

  Future<void> requestPermissions() async {
    final permissions = [
      Permission.camera,
    ];

    for (var permission in permissions) {
      if (await permission.isDenied || await permission.isPermanentlyDenied) {
        final status = await permission.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          log('Permission ${permission.toString()} denied');
        }
      }
    }
  }

  Future<void> openSettings(Permission permission) async {
    if (await permission.isPermanentlyDenied) {
      log('Opening app settings for ${permission.toString()}');
      await openAppSettings();
    }
  }
}
