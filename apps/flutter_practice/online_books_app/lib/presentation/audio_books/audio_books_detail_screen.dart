import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/audio_books/audio_player_screen.dart';
import 'package:online_books_app/presentation/audio_books/controller/audio_book_controller.dart';
import 'package:online_books_app/presentation/audio_books/model/audio_books_model.dart';
import 'package:online_books_app/presentation/saved/controller/saved_controller.dart';
import 'package:online_books_app/theme/custom_button_style.dart';
import 'package:online_books_app/theme/custom_text_style.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:online_books_app/widgets/app_bar/appbar_subtitle.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';
import 'package:online_books_app/widgets/custom_outlined_button.dart';

class AudioBooksDetailScreen extends StatelessWidget {
  AudioBooksDetailScreen({super.key});

  final AudioBookController controller = Get.find<AudioBookController>();
  final SavedAudioBooksController savedAudioBooksController =
      Get.put(SavedAudioBooksController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appTheme.yellow700,
        title: Obx(() => AppbarSubtitle(text: controller.bookTitle.value)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.w),
                child: CustomImageView(
                  imagePath: controller.bookImagePath.value,
                  height: 300.h,
                  width: double.maxFinite,
                  radius: BorderRadius.circular(30.h),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Obx(
              () => Text(
                controller.bookTitle.value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(
              () => Text(
                "by ${controller.bookAuthor.value}",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            SizedBox(height: 8.h),
            _buildSettingRow(),
            Obx(
              () => Text(
                controller.bookDescription.value,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 18.h),
            _buildCategoryRow(),
            Spacer(
              flex: 49,
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 40.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNextButton(),
                  _buildSaveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSettingRow() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.iconSmile,
            height: 24.h,
            width: 24.h,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 4.h,
              ),
              child: Text(
                "lbl_23_reviews".tr,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 24.h,
                      decoration: BoxDecoration(
                        color: appTheme.yellow700,
                        borderRadius: BorderRadius.circular(1.h),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.star,
                          height: 22.h,
                          width: 22.w,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 4),
                        Obx(
                          () => Text(
                            controller.start.value.toString(),
                            style: CustomTextStyles.bodyMediumBlack900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgThumbsUpAmber300,
            height: 16.h,
            width: 16.h,
            margin: EdgeInsets.only(left: 4.h),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 4.h),
              child: Text(
                "lbl_coin_240".tr,
                style: CustomTextStyles.bodyMediumBlack900,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScienceButton() {
    return CustomOutlinedButton(
      height: 32.h,
      width: 80.w,
      text: "lbl_science".tr,
      onPressed: () {},
      buttonTextStyle: theme.textTheme.titleMedium!,
    );
  }

  Widget _buildHistoryButton() {
    return CustomOutlinedButton(
      height: 32.h,
      width: 80.w,
      text: "lbl_history".tr,
      onPressed: () {},
      buttonTextStyle: theme.textTheme.titleMedium!,
      margin: EdgeInsets.only(left: 16.h),
    );
  }

  Widget _buildCategoryRow() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          _buildScienceButton(),
          _buildHistoryButton(),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return CustomElevatedButton(
      width: 112.w,
      height: 36.h,
      text: "lbl_listen".tr,
      onPressed: () {
        Get.to(() => AudioPlayerScreen(
              title: controller.bookTitle.value,
              audioUrl:
                  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
            ));
      },
      buttonStyle: CustomButtonStyles.outlinePrimary,
      buttonTextStyle: CustomTextStyles.titleLargeBluegray90001.copyWith(
        color: appTheme.whiteA700,
      ),
    );
  }

  Widget _buildSaveButton() {
    return CustomOutlinedButton(
      width: 112.w,
      height: 36.h,
      text: "lbl_save".tr,
      onPressed: () {
        final audioBook = AudioBooks(
          id: controller.bookTitle.value,
          fullName: controller.bookTitle.value,
          avatarUrl: controller.bookImagePath.value,
          biography: controller.bookDescription.value,
          duration: controller.duration.value,
        );
        savedAudioBooksController.addAudioBookToSaved(audioBook);
        Get.snackbar(
          "Audio Book Saved",
          "The audio book has been saved to your library.",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
          icon: Icon(Icons.check, color: Colors.white),
        );
      },
      buttonStyle: CustomButtonStyles.outlinePrimaryBL18,
      buttonTextStyle: CustomTextStyles.titleLargeBluegray90001,
    );
  }
}
