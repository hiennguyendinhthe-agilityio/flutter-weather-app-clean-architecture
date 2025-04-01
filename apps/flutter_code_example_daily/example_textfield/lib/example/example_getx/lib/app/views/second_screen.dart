import 'package:example_textfield/example/example_getx/lib/app/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondScreen extends StatelessWidget {
  final List<String> items = List.generate(10, (index) => "Item ${index + 1}");

  SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.find();

    return Scaffold(
      appBar: AppBar(title: Text("second".tr)),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            onTap: () {
              Get.snackbar("Selected", "You clicked on ${items[index]}");
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigationController.changeTabIndex(0);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
