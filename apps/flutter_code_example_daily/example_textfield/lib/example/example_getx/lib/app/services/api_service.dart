import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    debugPrint("Data fetched from API");
  }
}
