import 'package:online_books_app/core/app_export.dart';
import 'package:online_books_app/presentation/profile/model/imformationlist_item_model.dart';

class ProfileModel {
  Rx<List<InformationlistItemModel>> informationlistItemList =
      Rx(List.generate(3, (index) => InformationlistItemModel()));
}
