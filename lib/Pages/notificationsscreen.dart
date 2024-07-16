import 'package:citiguide/controllers/NotificationsController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  final dynamic data;

  const NotificationsScreen({super.key, this.data});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Map<String, dynamic> payload = {};
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    if (widget.data is RemoteMessage) {
      payload = widget.data.data;
    } else if (widget.data is Map<String, dynamic>) {
      payload = widget.data;
    }
    print("Processed Payload: $payload");

    // Add the notification payload to the controller
    if (payload.isNotEmpty) {
      String message =
          payload.containsKey('message') ? payload['message'] : 'No message';
      notificationController.addNotification(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Obx(() {
        if (notificationController.notifications.isEmpty) {
          return Center(child: Text('No notifications yet'));
        }
        return ListView.builder(
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            String notification = notificationController.notifications[index];
            return ListTile(
              title: Text(notification),
              subtitle: Text(payload.toString()),
              leading: CircleAvatar(
                child: Text('Icon'),
              ),
              onTap: () {
                // Handle tapping on a notification
              },
            );
          },
        );
      }),
    );
  }
}
