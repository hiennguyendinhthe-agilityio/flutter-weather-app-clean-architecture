import 'package:get/get.dart';
import 'package:online_books_app/presentation/onboarding/onboardingtwo_screen/controller/onboardingtwo_controller.dart';

class OnboardingtwoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingtwoController());
  }
}
