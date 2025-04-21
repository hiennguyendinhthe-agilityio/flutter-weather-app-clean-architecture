import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/app_decoration.dart';
import 'package:online_books_app/core/theme/custom_button_style.dart';
import 'package:online_books_app/core/theme/custom_text_style.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/auth/login/controller/login_controller.dart';
import 'package:online_books_app/widgets/custom_checkbox_button.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';
import 'package:online_books_app/widgets/custom_text_button.dart';
import 'package:online_books_app/widgets/custom_text_form_field.dart';

class LoginScreen extends GetWidget<LoginController> {
  LoginScreen({
    super.key,
  });
  @override
  final LoginController controller = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.onPrimary,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.fillOnPrimaryTwo,
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 26.h,
              top: 144.h,
              right: 26.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(right: 8.h),
      child: Column(
        children: [
          Obx(
            () => CustomTextFormField(
              controller: controller.emailController,
              hintText: "lbl_email".tr,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgUser,
                  height: 22.h,
                  width: 22.w,
                  fit: BoxFit.contain,
                ),
              ),
              prefixConstraints: BoxConstraints(
                minWidth: 48.w,
              ),
              contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
              errorText: controller.emailError.value.isEmpty
                  ? null
                  : controller.emailError.value,
              onChanged: (value) {
                controller.validateEmail(value);
              },
              validator: (value) {
                controller.validateEmail(value ?? '');
                return controller.emailError.value.isEmpty
                    ? null
                    : controller.emailError.value;
              },
            ),
          ),
          SizedBox(height: 30.h),
          Obx(
            () => CustomTextFormField(
              controller: controller.passwordController,
              hintText: "lbl_password".tr,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgLock,
                  height: 22.h,
                  width: 24.w,
                  fit: BoxFit.contain,
                ),
              ),
              prefixConstraints: BoxConstraints(
                minWidth: 48.w,
              ),
              suffix: InkWell(
                onTap: () {
                  controller.isShowPassword.value =
                      !controller.isShowPassword.value;
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.h, 12.h, 14.h, 12.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgEye,
                    height: 22.h,
                    width: 22.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              suffixConstraints: BoxConstraints(
                minWidth: 48.w,
              ),
              obscureText: controller.isShowPassword.value,
              contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
              errorText: controller.passwordError.value.isEmpty
                  ? null
                  : controller.passwordError.value,
              onChanged: (value) {
                controller.validatePassword(value);
              },
              validator: (value) {
                controller.validatePassword(value ?? '');
                return controller.passwordError.value.isEmpty
                    ? null
                    : controller.passwordError.value;
              },
            ),
          ),
          SizedBox(height: 11.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 8.h, right: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => CustomCheckboxButton(
                    text: "lbl_remember_me".tr,
                    richText: TextSpan(
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "lbl_remember_me".tr,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ]),
                    value: controller.isRememberMe.value,
                    textStyle: CustomTextStyles.bodySmallErrorContainer,
                    onChange: (value) {
                      controller.isRememberMe.value = value;
                    },
                  ),
                ),
                Text(
                  "msg_forgot_password?".tr,
                  style: theme.textTheme.bodyLarge,
                )
              ],
            ),
          ),
          SizedBox(
            height: 84.h,
          ),
          Obx(
            () => CustomElevatedButton(
              height: 40.h,
              text: controller.isLoading.value
                  ? "logging in..."
                  : "lbl_log_in".tr,
              margin: EdgeInsets.only(right: 8.h),
              buttonStyle: CustomButtonStyles.outlinePrimaryTL12,
              buttonTextStyle: CustomTextStyles.titleLargeDosisGray50,
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.login();
                      }
                    },
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() {
            if (controller.biometricEnabled) {
              return IconButton(
                onPressed: () async {
                  Get.dialog(Center(child: CircularProgressIndicator()));
                  try {
                    final success =
                        await controller.authenticateWithBiometrics();
                    Get.back();
                    if (success) Get.offAllNamed('/home_initial_page');
                  } catch (e) {
                    Get.back();
                  }
                },
                icon: Icon(
                  Platform.isIOS ? Icons.tag_faces_outlined : Icons.fingerprint,
                  size: 40,
                ),
              );
            }
            return SizedBox();
          }),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "msg_don_t_have_an_account".tr,
                style: theme.textTheme.bodyLarge,
              ),
              CustomTextButton(
                text: "lbl_sign_up".tr,
                style: CustomTextStyles.titleMediumGray50,
                onPressed: () {
                  Get.toNamed('/signup_screen');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
