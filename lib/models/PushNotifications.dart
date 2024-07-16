import 'dart:convert';

import 'package:citiguide/Pages/notificationsscreen.dart';
import 'package:citiguide/controllers/LoginController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future<void> init() async {
    print("Requesting notification permission...");
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    print("Getting device token...");
    String? token = await getDeviceToken();
    if (token != null) {
      print("Device token: $token");
      saveUserToken(token);
    } else {
      print("Failed to get device token.");
    }
  }

  // get the fcm device token
  static Future<String?> getDeviceToken({int maxRetries = 3}) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("Device token: $token");

      if (token != null) {
        await saveUserToken(token);
        return token;
      } else {
        print("Failed to retrieve device token");
        return null;
      }
    } catch (e) {
      print("Error getting device token: $e");
      if (maxRetries > 0) {
        print("Retrying after 10 seconds...");
        await Future.delayed(Duration(seconds: 10));
        return getDeviceToken(maxRetries: maxRetries - 1);
      } else {
        return null;
      }
    }
  }

  static Future<void> saveUserToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not logged in, token not saved.");
      return;
    }

    String userEmail = user.email ?? "";
    Map<String, dynamic> data = {
      "token": token,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users') // Use 'users' collection instead of 'user_data'
          .doc(userEmail)
          .set(data, SetOptions(merge: true)); // Merge with existing data

      print("Token added to Firestore for user: $userEmail");
    } catch (e) {
      print("Error in saving token to Firestore: $e");
    }
  }

  // // initalize local notifications
  static Future localNotiInit() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    // request notification permissions for android 13 or above
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    final data = jsonDecode(notificationResponse.payload ?? '{}');
    print('Data received on notification tap: $data');
    Get.to(() => NotificationsScreen(data: data));
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
