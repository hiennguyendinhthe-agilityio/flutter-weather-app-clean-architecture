import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/onboarding/onboardingtwo_screen/controller/onboardingtwo_controller.dart';
import 'package:online_books_app/theme/app_decoration.dart';
import 'package:online_books_app/theme/custom_button_style.dart';
import 'package:online_books_app/theme/custom_text_style.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:online_books_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:online_books_app/widgets/app_bar/appbar_title.dart';
import 'package:online_books_app/widgets/app_bar/custom_app_bar.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingtwoScreen extends GetWidget<OnboardingtwoController> {
  const OnboardingtwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SizedBox(
            height: 854.h,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgDnn1,
                  height: 430.h,
                  width: 430.h,
                  alignment: Alignment.topCenter,
                ),
                _buildAudioBookSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leadingWidth: 48.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 24.h),
        onTap: () {
          Get.back();
        },
      ),
      actions: [
        AppbarTitle(
          text: "lbl_skip".tr,
          margin: EdgeInsets.only(right: 25.h),
          onTap: controller.skip,
        )
      ],
    );
  }

  Widget _buildAudioBookSection() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 28.h,
              top: 18.h,
              bottom: 18.h,
            ),
            decoration: AppDecoration.primaryappGrandis,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 10.h,
                    child: AnimatedSmoothIndicator(
                      activeIndex: 1,
                      count: 2,
                      effect: ScrollingDotsEffect(
                        activeDotColor: appTheme.deepOrange300,
                        dotColor: theme.colorScheme.primary,
                        dotHeight: 10.h,
                        dotWidth: 10.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 34.h),
                Text(
                  "lbl_audio_books".tr,
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: 342.h,
                  child: Text(
                    "msg_spark_your_child_s".tr,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleLargeDosisBluegray900,
                  ),
                ),
                SizedBox(height: 26.h),
                CustomElevatedButton(
                  text: "lbl_next".tr,
                  width: 112.h,
                  height: 36.h,
                  onPressed: controller.nextPage,
                  buttonStyle: CustomButtonStyles.outlinePrimary,
                  buttonTextStyle: CustomTextStyles.titleLargeDosisGray50,
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
