import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/home/controller/home_controller.dart';
import 'package:online_books_app/presentation/home/home_initial_page.dart';
import 'package:online_books_app/presentation/profile/profile_screen.dart';
import 'package:online_books_app/presentation/saved/controller/saved_controller.dart';
import 'package:online_books_app/presentation/saved/saved_screen.dart';
import 'package:online_books_app/presentation/settings/setting_screen.dart';
import 'package:online_books_app/theme/app_decoration.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:online_books_app/widgets/custom_bottom_bar.dart';

class HomeScreen extends GetWidget<HomeController> {
  HomeScreen({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Get.put(SavedBooksController());
    Get.put(SavedAudioBooksController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.whiteA700,
      body: Container(
        width: double.maxFinite,
        decoration: AppDecoration.fillWhiteA700,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return IndexedStack(
                  index: homeController.selectedIndex.value,
                  children: [
                    HomeInitialPage(),
                    SavedScreen(),
                    ProfileScreen(),
                    SettingsScreen(),
                  ],
                );
              }),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: CustomBottomBar(
          onChanged: (BottomBarEnum type) {
            homeController.selectedIndex.value = type.index;
          },
        ),
      ),
    );
  }
}
