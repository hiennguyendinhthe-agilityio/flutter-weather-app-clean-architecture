import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/app_decoration.dart';
import 'package:online_books_app/core/theme/custom_button_style.dart';
import 'package:online_books_app/core/theme/custom_text_style.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/e_books/ebook_detail_screen.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:online_books_app/presentation/e_books/widgets/item_list_ebooks_widget.dart';
import 'package:online_books_app/presentation/home/controller/home_controller.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';
import 'package:shimmer/shimmer.dart';

class HomeInitialPage extends StatelessWidget {
  const HomeInitialPage({super.key});

  HomeController get controller => Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(
          left: 14.h,
          top: 16.h,
          right: 14.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.h,
            ),
            _buildLoginSection(),
            SizedBox(
              height: 10.h,
            ),
            _buildAudioBooksSection(),
            SizedBox(
              height: 12.h,
            ),
            _buildRecommendationsSection(),
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 4.h,
              ),
              child: Text(
                "lbl_remaining".tr,
                style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            SizedBox(
              height: 36.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return Container(
      height: 264.h,
      width: double.maxFinite,
      decoration: AppDecoration.stack5,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 40.h),
                            child: Text(
                              "lbl_log_in".tr,
                              style: CustomTextStyles.titleMediumBlueGray900,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.toNamed("/notification_screen");
                              },
                              icon: Icon(Icons.notifications,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgDns1,
            height: 192.h,
            width: 302.h,
          ),
          Padding(
            padding: EdgeInsets.all(8.h),
            child: CustomElevatedButton(
              height: 32.h,
              width: 96.w,
              text: "lbl_read".tr,
              margin: EdgeInsets.only(
                left: 12.h,
                right: 16.h,
              ),
              buttonStyle: CustomButtonStyles.outlinePrimary,
              buttonTextStyle: CustomTextStyles.titleMediumGray50,
              alignment: Alignment.bottomLeft,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.h,
                bottom: 64.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "lbl_ready_for_a".tr,
                    style: CustomTextStyles.titleLarge_1,
                  ),
                  Text(
                    "lbl_journey".tr,
                    style: CustomTextStyles.headlineSmallBlack900,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksSection() {
    return Expanded(
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_books".tr,
            style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed("/item_list_ebook");
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgRecommended1,
              height: 160.h,
              width: double.maxFinite,
              radius: BorderRadius.circular(12.h),
              margin: EdgeInsets.only(right: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioBooksSection() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          _buildBooksSection(),
          Expanded(
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "lbl_audio_books".tr,
                  style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed("/item_list_audio_book");
                  },
                  child: CustomImageView(
                    imagePath: ImageConstant.imgRecommended1160x192,
                    height: 160.h,
                    width: double.maxFinite,
                    radius: BorderRadius.circular(12.h),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    final HomeController controller = Get.find<HomeController>();
    final random = Random();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_recommended".tr,
          style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
        ),
        SizedBox(height: 10.h),
        Obx(() {
          if (controller.authorController.isLoading.value) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ItemListEbooksWidget(
                imagePath: ImageConstant.imgRectangle119,
                title: 'Loading...',
                author: 'Loading...',
                category: 'Loading...',
                description: 'Loading...',
                onTap: () {},
              ),
            );
          }

          if (controller.authorController.authors.isEmpty) {
            return Center(child: Text('No recommended books found'));
          }

          Books book = controller.authorController.authors[
              random.nextInt(controller.authorController.authors.length)];

          return ItemListEbooksWidget(
            imagePath: book.avatarUrl ?? ImageConstant.imgRectangle119,
            title: book.fullName ?? 'Unknown',
            author: book.fullName ?? 'Unknown',
            category: book.occupation ?? 'Unknown',
            description: book.biography ?? 'No biography available',
            onTap: () {
              Get.to(() => EBookDetailScreen(), arguments: book);
            },
          );
        }),
      ],
    );
  }
}
