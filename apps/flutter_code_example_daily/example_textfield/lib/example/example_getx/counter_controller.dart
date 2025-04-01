import 'package:get/get.dart';

class CounterController extends GetxController {
  var count = 0.obs; // Sử dụng "obs" để biến count trở thành Observable

  void increment() => count++;
}
