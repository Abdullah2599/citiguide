import 'dart:convert';

import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/Pages/notificationsscreen.dart';
import 'package:citiguide/Pages/splash.dart';
import 'package:citiguide/Pages/welcomescreen.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/controllers/NotificationsController.dart';
import 'package:citiguide/models/PushNotifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final NotificationController notificationController =
    Get.put(NotificationController());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Initializing Push Notifications...");
  await PushNotifications.init();
  print("Initializing Local Notifications...");
  await PushNotifications.localNotiInit();

  // Handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground: $payloadData");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
        title: message.notification!.title ?? "No Title",
        body: message.notification!.body ?? "No Body",
        payload: payloadData,
      );
    }
  });

  // Handle notification tap in background or terminated state
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    Get.to(() => NotificationsScreen(data: message.data));
  });

  // Handle notification tap when the app is terminated
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  // Check if the app was opened from a notification and handle the redirection
  if (message != null) {
    print("Launched from terminated state with data: ${message.data}");

    if (user != null) {
      // User is signed in, navigate to NotificationsScreen with data
      runApp(MyApp(
          isFirstTime: isFirstTime,
          user: user,
          notificationData: message.data));
    } else {
      // User is not signed in, navigate to NotificationsScreen with data
      runApp(MyApp(
          isFirstTime: isFirstTime,
          user: user,
          notificationData: message.data));
    }
  } else {
    // Regular app launch
    runApp(MyApp(isFirstTime: isFirstTime, user: user, notificationData: {}));
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final User? user;
  final Map<String, dynamic> notificationData;

  const MyApp({
    super.key,
    required this.isFirstTime,
    required this.user,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (isFirstTime) {
      home = WelcomScreen();
    } else if (user == null) {
      home = LoginPage();
    } else {
      home = CityScreen();
    }

    // If there is notification data and the user is signed in, open NotificationsScreen
    if (user != null && notificationData.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(() => NotificationsScreen(data: notificationData));
      });
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorTheme.primaryColor,
          brightness: Brightness.light,
          onPrimary: ColorTheme.primaryColor,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          dragHandleColor: ColorTheme.primaryColor,
        ),
      ),
    );
  }
}
