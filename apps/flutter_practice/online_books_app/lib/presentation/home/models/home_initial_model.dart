import 'package:get/get.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/presentation/home/models/homelistsection_item_model.dart';

class HomeInitialModel {
  Rx<List<HomelistsectionItemModel>> homelistsectionItemList = Rx([
    HomelistsectionItemModel(image: ImageConstant.imgRectangle119.obs),
    HomelistsectionItemModel(image: ImageConstant.imgRectangle121.obs),
    HomelistsectionItemModel(image: ImageConstant.imgRectangle122.obs),
    HomelistsectionItemModel(image: ImageConstant.imgRectangle123.obs),
  ]);
}
