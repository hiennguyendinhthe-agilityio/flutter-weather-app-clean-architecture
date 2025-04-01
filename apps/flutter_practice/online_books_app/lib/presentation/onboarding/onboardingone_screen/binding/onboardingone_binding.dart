import 'package:get/get.dart';
import 'package:online_books_app/presentation/onboarding/onboardingone_screen/controller/onboardingone_controller.dart';

class OnboardingoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingoneController());
  }
}
