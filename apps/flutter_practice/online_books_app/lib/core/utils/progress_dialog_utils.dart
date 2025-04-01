import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  /// Common method for showing progress dialog
  static void showProgressDialog({bool isCancellable = false}) async {
    if (!isProgressVisible) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isProgressVisible = true;
    }
  }

  /// Common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) {
      Get.back();
      isProgressVisible = false;
    }
  }
}
