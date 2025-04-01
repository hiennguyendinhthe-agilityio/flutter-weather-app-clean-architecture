import 'package:online_books_app/core/app_export.dart';

class InformationlistItemModel {
  InformationlistItemModel({this.id}) {
    id = id ?? Rx("");
  }

  Rx<String>? id;
}
