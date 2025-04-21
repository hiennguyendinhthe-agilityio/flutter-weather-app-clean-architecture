import 'package:get/get.dart';
import 'package:online_books_app/presentation/onboarding/onboardingthree_screen/model/onboardingthree_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingthreeController extends GetxController {
  Rx<OnboardingthreeModel> onboardingthreeModelObj = OnboardingthreeModel().obs;

  void goToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Get.offAllNamed('/login_screen');
  }
}
