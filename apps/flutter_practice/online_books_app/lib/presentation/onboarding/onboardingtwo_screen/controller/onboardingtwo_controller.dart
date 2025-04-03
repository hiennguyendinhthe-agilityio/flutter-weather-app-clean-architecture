import 'package:get/get.dart';
import 'package:online_books_app/presentation/onboarding/onboardingtwo_screen/model/onboardingtwo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingtwoController extends GetxController {
  Rx<OnboardingtwoModel> onboardingtwoModelObj = OnboardingtwoModel().obs;
  RxInt currentPage = 0.obs;
  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;

      if (currentPage.value == 1) {
        Get.toNamed('/onboardingtwo_screen');
      } else if (currentPage.value == 2) {
        Get.toNamed('/onboardingthree_screen');
      }
    }
  }

  void skip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarding_completed', true);
    Get.offAllNamed('/login_screen');
  }
}
