import 'package:citiguide/Pages/Favorites.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/controllers/LoginController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:citiguide/components/reusable/sizedbox.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

app_Bar(String text, bool truf, String screen) {
  return AppBar(
    automaticallyImplyLeading: truf,
    clipBehavior: Clip.hardEdge,
    foregroundColor: Colors.white,
    title: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    surfaceTintColor: Colors.transparent,
    backgroundColor: Color.fromARGB(255, 7, 206, 182),
    actions: [
      if (screen != 'Home')
        IconButton(
          onPressed: () {
            Get.defaultDialog(
              buttonColor: ColorTheme.primaryColor,
              confirmTextColor: Colors.white,
              onConfirm: () {
                LoginController.signOut();
              },
              onCancel: () {
                Get.back();
              },
              title: "Log out",
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are you sure to logout?"),
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        )
      else
        // IconButton(
        //   onPressed: () {
        //     Get.to(() => FavoritesScreen());
        //   },
        //   icon: Icon(
        //     Icons.star,
        //     color: Colors.white,
        //   ),
        // ),

        ElevatedButton.icon(
          icon: Icon(
            Icons.favorite,
            color: ColorTheme.primaryColor,
          ),
          onPressed: () {
            Get.to(() => FavoritesScreen());
          },
          label: Text(
            "Favorites",
            style: TextStyle(fontSize: 16, color: ColorTheme.primaryColor),
          ),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(150, 10),
              elevation: 5,
              // backgroundColor: ColorTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
        )
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
