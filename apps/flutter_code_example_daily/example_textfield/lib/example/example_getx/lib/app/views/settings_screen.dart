import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custom_button.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'switch_theme'.tr,
              onPressed: themeController.switchTheme,
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'change_language'.tr,
              onPressed: () {
                Get.toNamed(AppRoutes.language);
              },
            ),
          ],
        ),
      ),
    );
  }
}
