import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/home/controller/home_controller.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';

enum BottomBarEnum { home, save, user, settings }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({super.key, this.onChanged});

  RxInt selectedIndex = Get.find<HomeController>().selectedIndex;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.iconHome,
      activeIcon: ImageConstant.iconHome,
      type: BottomBarEnum.home,
    ),
    BottomMenuModel(
      icon: ImageConstant.iconSave,
      activeIcon: ImageConstant.iconSave,
      type: BottomBarEnum.save,
    ),
    BottomMenuModel(
      icon: ImageConstant.iconUser,
      activeIcon: ImageConstant.iconUser,
      type: BottomBarEnum.user,
    ),
    BottomMenuModel(
      icon: ImageConstant.iconSettings,
      activeIcon: ImageConstant.iconSettings,
      type: BottomBarEnum.settings,
    ),
  ];

  Function(BottomBarEnum)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CurvedNavigationBar(
        index: selectedIndex.value,
        height: 60.0,
        items: List.generate(bottomMenuList.length, (index) {
          return CustomImageView(
            imagePath: selectedIndex.value == index
                ? bottomMenuList[index].activeIcon
                : bottomMenuList[index].icon,
            height: 32.h,
            width: 34.h,
            color: selectedIndex.value == index
                ? theme.colorScheme.errorContainer
                : appTheme.blueGray900,
          );
        }),
        color: appTheme.gray50,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          selectedIndex.value = index;
          onChanged?.call(bottomMenuList[index].type);
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    required this.type,
  });

  String icon;
  String activeIcon;
  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
