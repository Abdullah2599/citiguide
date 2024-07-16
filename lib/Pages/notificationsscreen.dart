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
    Future.delayed(Duration.zero, () => processPayload());
  }

  void processPayload() {
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
            bool isRead = notification['isRead'] is bool
                ? notification['isRead']
                : notification['isRead'] == 'true';
            return Dismissible(
              key: Key(notification['timestamp'].toString()),
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                notificationController.deleteNotification(index);
              },
              child: GestureDetector(
                onTap: () {
                  Future.delayed(Duration.zero,
                      () => notificationController.markAsRead(index));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isRead ? Colors.cyan[100] : Colors.cyan,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(notification['title']),
                    subtitle: Text(notification['message']),
                    leading: CircleAvatar(
                      child: Text('Icon'),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
