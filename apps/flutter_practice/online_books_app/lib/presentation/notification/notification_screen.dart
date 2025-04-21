import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/notification/controller/notification_controller.dart';
import 'package:online_books_app/presentation/notification/detail_page.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
        actions: [
          Obx(() {
            PermissionStatus status =
                notificationController.notificationPermissionStatus.value;
            IconData icon;
            Color color;
            String tooltip;

            if (status.isGranted) {
              icon = Icons.notifications_active;
              color = Colors.green;
              tooltip = 'Notifications are enabled';
            } else if (status.isPermanentlyDenied) {
              icon = Icons.notifications_off;
              color = Colors.red;
              tooltip =
                  'Notifications are permanently denied (Click to open settings)';
            } else {
              icon = Icons.notifications_none;
              color = Colors.orange;
              tooltip = 'Notifications are disabled (Click to enable)';
            }

            return IconButton(
              icon: Icon(icon, color: color),
              tooltip: tooltip,
              onPressed: () {
                notificationController.checkAndRequestPermission(context);
              },
            );
          })
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (notificationController.notifications.isEmpty) {
                return Center(
                  child: Text(
                    'No Notifications',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                itemCount: notificationController.notifications.length,
                itemBuilder: (context, index) {
                  final notification = notificationController
                      .notifications.reversed
                      .toList()[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.message,
                          color: Theme.of(context).primaryColor),
                      title: Text(notification['title'] ?? 'No Title',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(notification['body'] ?? 'No Body'),
                      onTap: () {
                        final Map<String, String> detailData =
                            Map<String, String>.from(notification);
                        Get.to(() => DetailPage(notification: detailData));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
