import 'package:CityNavigator/Pages/Favorites.dart';
import 'package:CityNavigator/Pages/eventscreen.dart';
import 'package:CityNavigator/Pages/notificationsscreen.dart';
import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/controllers/LoginController.dart';
import 'package:CityNavigator/controllers/NotificationsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar app_Bar(String text, bool truf, String screen, city) {
  final NotificationController notificationController =
      Get.put(NotificationController());
  return AppBar(
    automaticallyImplyLeading: truf,
    clipBehavior: Clip.hardEdge,
    foregroundColor: Colors.white,
    title: Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    backgroundColor: const Color.fromARGB(255, 7, 206, 182),
    actions: [
      if (screen == 'Cities')
        Obx(() {
          int unreadCount = notificationController.unreadCount.value;
          return Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => const NotificationsScreen());
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
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
              content: const Column(
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
                  child: const Text(
                    'Cancel',
                    style:
                        TextStyle(color: Colors.black87), // Example text color
                  ),
                ),
                const SizedBox(width: 8), // Optional spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    LoginController login = Get.put(LoginController());
                    login.signOut();
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
                  child: const Text(
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
        Row(children: [
          TextButton(
            onPressed: () {
              Get.to(() => EventsScreen(
                    city: city,
                  ));
            },
            child: Text(
              'Events',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          IconButton(
              onPressed: () {
                Get.to(() => const FavoritesScreen());
              },
              icon: const Icon(
                Icons.favorite,
              )),
        ])
    ],
    leading: truf
        ? GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )
        : null,
  );
}
