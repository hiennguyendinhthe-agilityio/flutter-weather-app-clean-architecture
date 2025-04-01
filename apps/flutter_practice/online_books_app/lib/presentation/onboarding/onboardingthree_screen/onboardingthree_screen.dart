import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/onboarding/onboardingthree_screen/controller/onboardingthree_controller.dart';
import 'package:online_books_app/theme/app_decoration.dart';
import 'package:online_books_app/theme/custom_button_style.dart';
import 'package:online_books_app/theme/custom_text_style.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';

class OnboardingthreeScreen extends GetWidget<OnboardingthreeController> {
  const OnboardingthreeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: appTheme.gray50,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: AppDecoration.primaryappBlackSqueeze,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              left: 24.h,
              top: 80.h,
              right: 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buidLestStartSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buidLestStartSection() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 22,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_lets_start".tr,
            style: theme.textTheme.headlineLarge,
          ),
          CustomElevatedButton(
            text: "lbl_start".tr,
            width: 112.h,
            height: 36.h,
            onPressed: () {
              Get.find<OnboardingthreeController>().goToLogin();
            },
            buttonStyle: CustomButtonStyles.outlinePrimary,
            buttonTextStyle: CustomTextStyles.titleLargeDosisGray50,
          )
        ],
      ),
    );
  }
}
