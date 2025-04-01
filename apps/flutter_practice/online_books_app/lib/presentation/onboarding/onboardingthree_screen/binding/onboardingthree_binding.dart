import 'package:get/get.dart';
import 'package:online_books_app/presentation/onboarding/onboardingthree_screen/controller/onboardingthree_controller.dart';

class OnboardingthreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingthreeController());
  }
}
