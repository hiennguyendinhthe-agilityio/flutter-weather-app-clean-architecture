import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/app_decoration.dart';
import 'package:online_books_app/core/theme/custom_text_style.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/auth/login/controller/login_controller.dart';
import 'package:online_books_app/presentation/settings/controller/settings_controller.dart';
import 'package:online_books_app/presentation/settings/models/settings_model.dart';
import 'package:online_books_app/presentation/settings/widgets/custom_alert_dialog.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';
import 'package:online_books_app/widgets/custom_switch.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller =
      Get.put(SettingsController(SettingsModel().obs));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 16.h,
            top: 16.h,
            right: 16.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: 36,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "lbl_settings".tr,
                  style: CustomTextStyles.titleLargeDosisBluegray900,
                ),
                _buildAccountSection(),
                _buildNotificationSection(),
                _buildMoreSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 4,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            child: _buildNotificationIconRow(
              userOne: ImageConstant.iconUserSettings,
              notifications: "lbl_account".tr,
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 18.h,
              vertical: 14.h,
            ),
            decoration: AppDecoration.outlineGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: _buildChangeSettingsRow(
                    changePassword: "lbl_edit_profile".tr,
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildChangeSettingsRow(
                    changePassword: "lbl_change_password".tr,
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildChangeSettingsRow(
                    changePassword: "lbl_change_email".tr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    final SettingsController controller = Get.find<SettingsController>();

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 6,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            child: _buildNotificationIconRow(
              userOne: ImageConstant.iconMessageNotif,
              notifications: "lbl_notifications".tr,
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(18.h),
            decoration: AppDecoration.outlineGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            child: Column(
              spacing: 6,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Biometric Login",
                        style: theme.textTheme.bodyMedium,
                      ),
                      _buildBiometricSwitch(),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "lbl_email_notification".tr,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Obx(
                        () => CustomSwitch(
                          value: controller.isSelectedSwitch.value,
                          onChanged: (value) async {
                            controller.isSelectedSwitch.value = value;
                            if (value) {
                              await controller.requestNotificationPermission();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "msg_weekly_newsletter".tr,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Obx(
                        () => CustomSwitch(
                          value: controller.isSelectedSwitch1.value,
                          onChanged: (value) async {
                            controller.isSelectedSwitch1.value = value;
                            if (value) {
                              await controller.requestNotificationPermission();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "msg_app_notification".tr,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Obx(
                        () => CustomSwitch(
                          value: controller.isSelectedSwitch2.value,
                          onChanged: (value) async {
                            controller.isSelectedSwitch2.value = value;
                            if (value) {
                              await controller.requestNotificationPermission();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreSection() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 2,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            child: _buildNotificationIconRow(
              userOne: ImageConstant.iconMoreSquare,
              notifications: "lbl_more".tr,
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 18.h,
              vertical: 16.h,
            ),
            decoration: AppDecoration.outlineGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            child: Column(
              spacing: 14,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: _buildChangeSettingsRow(
                    changePassword: "lbl_language".tr,
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildChangeSettingsRow(
                    changePassword: "lbl_delete_account".tr,
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildChangeSettingsRow(
                    changePassword: "lbl_log_out".tr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIconRow({
    required String userOne,
    required String notifications,
  }) {
    return Row(
      children: [
        CustomImageView(
          imagePath: userOne,
          height: 24.h,
          width: 24.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(
            notifications,
            style: CustomTextStyles.titleLargeDosis.copyWith(
              color: appTheme.black900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangeSettingsRow(
      {required String changePassword, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        if (changePassword == "lbl_language".tr) {
          _showLanguageDialog();
        } else if (changePassword == "lbl_log_out".tr) {
          _showLogOutDialog();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            changePassword,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: appTheme.blueGray900,
            ),
          ),
          CustomImageView(
            onTap: onTap,
            imagePath: ImageConstant.iconArrowRight,
            height: 20.h,
            width: 22.h,
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final SettingsController controller = Get.find<SettingsController>();

    Get.dialog(
      CustomAlertDialog(
        title: "Choose Language",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("English"),
              onTap: () {
                controller.changeLanguage("en");
                Get.back();
              },
            ),
            ListTile(
              title: Text("Tiếng Việt"),
              onTap: () {
                controller.changeLanguage("vi");
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogOutDialog() {
    final SettingsController controller = Get.find<SettingsController>();

    Get.dialog(
      CustomAlertDialog(
        title: "Log Out",
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.logOut();
              Get.back();
            },
            child: Text("Log Out", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricSwitch() {
    final loginController = Get.find<LoginController>();

    return Obx(() {
      if (!loginController.isBiometricSupported) {
        return Text("Biometric check");
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => CustomSwitch(
                value: loginController.biometricEnabled,
                onChanged: (value) async {
                  if (value) {
                    final authenticated =
                        await loginController.authenticateWithBiometrics();
                    if (authenticated) {
                      await loginController.toggleBiometric(true);
                      Get.snackbar(
                          "Success", "Enabled biometric authentication");
                    }
                  } else {
                    await loginController.toggleBiometric(false);
                    Get.snackbar(
                        "Success", "Disabled biometric authentication");
                  }
                },
              )),
        ],
      );
    });
  }
}
