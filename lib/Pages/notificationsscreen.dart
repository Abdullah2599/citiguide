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

    if (payload.isNotEmpty) {
      String title =
          payload.containsKey('title') ? payload['title'] : 'No title';
      String message =
          payload.containsKey('message') ? payload['message'] : 'No message';
      notificationController.addNotification(title, message);
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
            var notification = notificationController.notifications[index];
            return ListTile(
              title: Text(notification['title']),
              subtitle: Text(notification['message']),
              leading: CircleAvatar(
                child: Text('Icon'),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  notificationController.deleteNotification(index);
                },
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
