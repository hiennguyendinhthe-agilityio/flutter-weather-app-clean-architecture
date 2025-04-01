import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:online_books_app/core/app_export.dart';
import 'package:online_books_app/presentation/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel> profileModelObj = ProfileModel().obs;

  ProfileController(
    this.profileModelObj,
  );

  final ImagePicker _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }
}
