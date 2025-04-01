import 'package:get/get.dart';
import 'package:online_books_app/core/utils/image_constant.dart';

class HomelistsectionItemModel {
  HomelistsectionItemModel({this.image, this.title}) {
    image = image ?? Rx(ImageConstant.imgRectangle119);
    title = title ?? Rx("lbl_english".tr);
  }

  Rx<String>? image;

  Rx<String>? title;
}
