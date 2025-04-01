import 'package:get/get.dart';
import 'package:online_books_app/data/models/selection_popup_model.dart';

class SignupModel {
  Rx<DateTime>? selecDateOfBirthInput = Rx((DateTime.now()));

  Rx<List<SelectionPopupModel>> dropdownItemList = Rx([
    SelectionPopupModel(
      id: 1,
      title: "occupation_doctor".tr,
    ),
    SelectionPopupModel(id: 2, title: "occupation_nurse".tr),
    SelectionPopupModel(id: 3, title: "occupation_engineer".tr),
    SelectionPopupModel(id: 4, title: "occupation_lawyer".tr),
    SelectionPopupModel(id: 5, title: "occupation_teacher".tr),
    SelectionPopupModel(id: 6, title: "occupation_scientist".tr),
    SelectionPopupModel(id: 7, title: "occupation_artist".tr),
    SelectionPopupModel(id: 8, title: "occupation_surgeon".tr),
  ]);
}
