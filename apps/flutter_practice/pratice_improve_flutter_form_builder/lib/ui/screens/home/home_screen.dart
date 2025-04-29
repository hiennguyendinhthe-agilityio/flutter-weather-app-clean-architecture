import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/config/routes/app_pages.dart';
import 'package:pratice_improve_flutter_form_builder/controllers/login_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  LoginController get loginController {
    if (Get.isRegistered<LoginController>()) {
      return Get.find<LoginController>();
    } else {
      print("Warning: LoginController not found. Creating temporary one.");
      return Get.put(LoginController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              Get.defaultDialog(
                title: "Confirm Logout",
                middleText: "Are you sure you want to log out?",
                textConfirm: "Logout",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                onConfirm: () async {
                  await loginController.logout();

                  Get.offAllNamed(Routes.login);
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  loginController.isRememberMe.value
                      ? 'Remember me was checked.'
                      : 'Remember me was not checked.',
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.snackbar('Info', 'Navigate to other feature!');
              },
              child: const Text('Go to Feature X'),
            )
          ],
        ),
      ),
    );
  }
}
