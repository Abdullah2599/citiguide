import 'package:citiguide/Pages/Favorites.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/Pages/notificationsscreen.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/controllers/LoginController.dart';
import 'package:citiguide/controllers/NotificationsController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

AppBar app_Bar(String text, bool truf, String screen) {
  final NotificationController notificationController =
      Get.put(NotificationController());
  return AppBar(
    automaticallyImplyLeading: truf,
    clipBehavior: Clip.hardEdge,
    foregroundColor: Colors.white,
    title: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromARGB(255, 7, 206, 182),
    actions: [
      if (screen == 'Cities')
        Obx(() {
          int unreadCount = notificationController.unreadCount.value;
          return Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => NotificationsScreen());
                },
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        }),
      if (screen == 'Profile')
        IconButton(
          onPressed: () {
            Get.defaultDialog(
              radius: 5,
              title: "Log out",
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are you sure you want to logout?"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Colors.grey[200], // Example background color
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style:
                        TextStyle(color: Colors.black87), // Example text color
                  ),
                ),
                SizedBox(width: 8), // Optional spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    LoginController.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor:
                        ColorTheme.primaryColor, // Your primary color
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Log out',
                    style: TextStyle(color: Colors.white), // Example text color
                  ),
                ),
              ],
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      if (screen == 'Home')
        IconButton(
            onPressed: () {
              Get.to(() => FavoritesScreen());
            },
            icon: Icon(
              Icons.favorite,
            ))
    ],
    leading: truf
        ? GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )
        : null,
  );
}
