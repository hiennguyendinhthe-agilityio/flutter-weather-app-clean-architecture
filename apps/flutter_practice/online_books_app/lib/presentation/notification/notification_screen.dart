import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/notification/controller/notification_controller.dart';

import 'detail_page.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notifications'),
        centerTitle: true,
      ),
      body: notificationController.notifications.isEmpty
          ? Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Obx(() {
              return ListView.builder(
                itemCount: notificationController.notifications.length,
                itemBuilder: (context, index) {
                  final notification =
                      notificationController.notifications[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: ListTile(
                      title: Text(notification['title'] ?? 'No Title'),
                      subtitle: Text(notification['body'] ?? 'No Body'),
                      onTap: () {
                        Get.to(() => DetailPage(notification: notification));
                      },
                    ),
                  );
                },
              );
            }),
    );
  }
}
