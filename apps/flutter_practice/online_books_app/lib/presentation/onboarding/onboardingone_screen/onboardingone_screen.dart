import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/onboarding/onboardingone_screen/controller/onboardingone_controller.dart';
import 'package:online_books_app/theme/app_decoration.dart';
import 'package:online_books_app/theme/custom_button_style.dart';
import 'package:online_books_app/theme/custom_text_style.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:online_books_app/widgets/app_bar/appbar_title.dart';
import 'package:online_books_app/widgets/app_bar/custom_app_bar.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingoneScreen extends GetWidget<OnboardingoneController> {
  const OnboardingoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppBar(),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: AppDecoration.fillOnPrimary,
        child: SafeArea(
          child: Container(
            height: 864.h,
            padding: EdgeInsets.symmetric(vertical: 54.h),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 474.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgBookDinosaurs1,
                          height: 474.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 10.h,
                            margin: EdgeInsets.only(bottom: 46.h),
                            child: AnimatedSmoothIndicator(
                              activeIndex: controller.currentPage.value,
                              count: 2,
                              effect: ScrollingDotsEffect(
                                spacing: 6,
                                activeDotColor: appTheme.deepOrange300,
                                dotColor: theme.colorScheme.primary,
                                dotHeight: 10.h,
                                dotWidth: 10.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _builDiverseBookSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      actions: [
        AppbarTitle(
          text: "lbl_skip".tr,
          margin: EdgeInsets.only(right: 25.h),
          onTap: controller.skip,
        ),
      ],
    );
  }

  Widget _builDiverseBookSection() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 28.h,
        right: 28.h,
      ),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_diverse_books".tr,
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(
            width: 330.h,
            child: Text(
              "msg_from_interactive".tr,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.titleLargeDosisBluegray900,
            ),
          ),
          CustomElevatedButton(
            text: "lbl_next".tr,
            width: 112.h,
            height: 36.h,
            onPressed: controller.nextPage,
            buttonStyle: CustomButtonStyles.outlinePrimary,
            buttonTextStyle: CustomTextStyles.titleLargeDosisGray50,
          ),
        ],
      ),
    );
  }
}
