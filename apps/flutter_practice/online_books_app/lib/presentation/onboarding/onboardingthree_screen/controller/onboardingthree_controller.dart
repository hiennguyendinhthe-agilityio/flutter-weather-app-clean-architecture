import 'package:get/get.dart';
import 'package:online_books_app/presentation/onboarding/onboardingthree_screen/model/onboardingthree_model.dart';

class OnboardingthreeController extends GetxController {
  Rx<OnboardingthreeModel> onboardingthreeModelObj = OnboardingthreeModel().obs;
  void goToLogin() {
    Get.offAllNamed('/login_screen');
  }
}
