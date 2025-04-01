import 'package:example_textfield/example/example_getx/lib/app/views/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final NavigationController navigationController =
      Get.put(NavigationController());

  final List<Widget> pages = [
    const Center(child: Text("Home Page", style: TextStyle(fontSize: 24))),
    SecondScreen(),
    const SettingsScreen(),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("home".tr)),
      body: Obx(() => pages[navigationController.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navigationController.selectedIndex.value,
            onTap: navigationController.changeTabIndex,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: "home".tr),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.pages), label: "second".tr),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings), label: "settings".tr),
            ],
          )),
    );
  }
}
