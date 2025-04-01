import 'package:get/get.dart';
import 'package:online_books_app/presentation/onboarding/onboardingone_screen/models/onboardingone_model.dart';

class OnboardingoneController extends GetxController {
  Rx<OnboardingoneModel> onboardingoneModel = OnboardingoneModel().obs;
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

  void skip() {
    Get.offAllNamed('/login_screen');
  }
}
