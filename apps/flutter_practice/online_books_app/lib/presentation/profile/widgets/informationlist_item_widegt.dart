import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/profile/controller/profile_controller.dart';
import 'package:online_books_app/presentation/profile/model/imformationlist_item_model.dart';
import 'package:online_books_app/theme/theme_helper.dart';

class InformationlistItemWidget extends StatelessWidget {
  InformationlistItemWidget(this.informationlistItemModelObj, {super.key});

  final InformationlistItemModel informationlistItemModelObj;

  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68.h,
      margin: EdgeInsets.only(
        top: 6.h,
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "lbl_95".tr,
              style: theme.textTheme.titleLarge,
            ),
            TextSpan(
              text: "lbl_books_you_read".tr,
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
