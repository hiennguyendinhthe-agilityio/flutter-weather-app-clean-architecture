import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custom_button.dart'; // Import CustomButton

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('language'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "🇺🇸 English",
              onPressed: () {
                Get.updateLocale(const Locale('en', 'US'));
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "🇻🇳 Tiếng Việt",
              onPressed: () {
                Get.updateLocale(const Locale('vi', 'VN'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
