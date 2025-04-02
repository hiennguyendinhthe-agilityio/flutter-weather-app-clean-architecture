import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/app_decoration.dart';
import 'package:online_books_app/core/theme/custom_text_style.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';

class ItemListEbooksWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String author;
  final String category;
  final String description;
  final VoidCallback onTap;

  const ItemListEbooksWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 6.h,
      ),
      decoration: AppDecoration.outlineGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          CustomImageView(
            imagePath: imagePath.isNotEmpty
                ? imagePath
                : ImageConstant.imgRecommended1160x192,
            height: 120.h,
            width: 90.h,
            radius: BorderRadius.circular(12.h),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CustomTextStyles.titleLargeConcertOneBlack900Regular_1,
                ),
                SizedBox(height: 4.h),
                Text(
                  "By $author",
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  category,
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.bodySmallBluegray90001,
                ),
                SizedBox(height: 4.h),
                CustomElevatedButton(
                  height: 24.h,
                  width: 72.w,
                  text: "lbl_read".tr,
                  margin: EdgeInsets.only(right: 4.h),
                  alignment: Alignment.centerRight,
                  onPressed: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
