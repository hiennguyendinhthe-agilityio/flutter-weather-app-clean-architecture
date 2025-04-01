import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/home/controller/home_controller.dart';
import 'package:online_books_app/presentation/home/models/homelistsection_item_model.dart';
import 'package:online_books_app/theme/app_decoration.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';

class HomelistsectionItemWidget extends StatelessWidget {
  HomelistsectionItemWidget(this.homelistsectionItemModelObj, {super.key});

  final HomelistsectionItemModel homelistsectionItemModelObj;
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      width: 90.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => CustomImageView(
              imagePath: homelistsectionItemModelObj.image!.value,
              height: 120.h,
              width: double.maxFinite,
              radius: BorderRadius.circular(12.h),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(right: 6.h),
              decoration: AppDecoration.gradientPrimaryContainerToGrayB
                  .copyWith(borderRadius: BorderRadiusStyle.customBorderBL12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
