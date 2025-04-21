import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_books_app/core/theme/app_decoration.dart';
import 'package:online_books_app/core/theme/custom_text_style.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/profile/controller/profile_controller.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(
    ProfileController(),
  );

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.yellow700,
        centerTitle: true,
        title: Text(
          "lbl_profile".tr,
          style: CustomTextStyles.titleLargeDosisBluegray900,
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_profile.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: 28,
              children: [
                _buildProfileStack(),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 16.h,
                    right: 26.h,
                    bottom: 16.h,
                  ),
                  child: Column(
                    spacing: 28,
                    children: [
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem('95', 'books you read'),
                            VerticalDivider(
                              width: 1.h,
                              thickness: 1.h,
                              color: appTheme.gray500,
                            ),
                            _buildStatItem('12', 'books you saved'),
                            VerticalDivider(
                              width: 1.h,
                              thickness: 1.h,
                              color: appTheme.gray500,
                            ),
                            _buildStatItem('2500', 'coins you earned'),
                          ],
                        ),
                      ),
                      _buildLibrarySection(),
                      _buildRemainingSection(),
                      SizedBox(
                        height: 38.h,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _buildProfileStack() {
    return SizedBox(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: AppDecoration.column12,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 52.h,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImagePickerOptions();
                          },
                          child: Obx(() => CircleAvatar(
                                radius: 80.h,
                                backgroundImage: controller
                                            .profileImage.value !=
                                        null
                                    ? FileImage(controller.profileImage.value!)
                                    : AssetImage(ImageConstant.imgRecommended1)
                                        as ImageProvider,
                              )),
                        ),
                        Text(
                          "lbl_jane_doe".tr,
                          style: CustomTextStyles.titleLargeDosis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery Image'),
            onTap: () {
              controller.pickImage(ImageSource.gallery);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera Image'),
            onTap: () {
              controller.pickImage(ImageSource.camera);
              Get.back();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  _buildLibrarySection() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "lbl_library".tr,
              style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
              vertical: 6.h,
            ),
            decoration: AppDecoration.outlineGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 118.h,
                          width: 120.h,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgRecommended1,
                                height: 118.h,
                                width: 96.h,
                                radius: BorderRadius.circular(10.h),
                                alignment: Alignment.centerLeft,
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgRecommended1,
                                height: 118.h,
                                width: 96.h,
                                radius: BorderRadius.circular(10.h),
                                alignment: Alignment.centerRight,
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgRecommended1,
                                height: 118.h,
                                width: 96.h,
                                radius: BorderRadius.circular(10.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "msg_you_have_35_books".tr,
                                style: CustomTextStyles.titleSmallBluegray900,
                              ),
                              Text(
                                "msg_let_s_start_reading".tr,
                                style: CustomTextStyles.bodySmallBluegray900,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomElevatedButton(
                  width: 72.w,
                  height: 32.h,
                  text: "lbl_see".tr,
                  margin: EdgeInsets.only(top: 72.h, left: 2.h, bottom: 4.h),
                  alignment: Alignment.bottomRight,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRemainingSection() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "lbl_remaining".tr,
              style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
              vertical: 6.h,
            ),
            decoration: AppDecoration.outlineGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 118.h,
                          width: 120.h,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgRecommended1,
                                height: 118.h,
                                width: 96.h,
                                radius: BorderRadius.circular(10.h),
                                alignment: Alignment.centerLeft,
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgRecommended1,
                                height: 118.h,
                                width: 96.h,
                                radius: BorderRadius.circular(10.h),
                                alignment: Alignment.centerRight,
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgRecommended1,
                                height: 118.h,
                                width: 96.h,
                                radius: BorderRadius.circular(10.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            spacing: 6,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "msg_you_have_35_books".tr,
                                style: CustomTextStyles.titleSmallBluegray900,
                              ),
                              Text(
                                "msg_let_s_start_reading".tr,
                                style: CustomTextStyles.bodySmallBluegray900,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomElevatedButton(
                  width: 72.w,
                  height: 32.h,
                  text: "lbl_read".tr,
                  margin: EdgeInsets.only(top: 72.h, left: 2.h, bottom: 4.h),
                  alignment: Alignment.bottomRight,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
