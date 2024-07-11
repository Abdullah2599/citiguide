import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/controllers/LoginController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:citiguide/components/reusable/sizedbox.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

app_Bar(String text, bool truf) {
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
      IconButton(
          onPressed: () {
            Get.defaultDialog(
              onConfirm: () {
                LoginController.signOut();
              },
              onCancel: () => {Get.back()},
              title: "Logout",
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.question_mark,
                    size: 40,
                  ),
                  sizedBox(),
                  Text("Are you sure to logout!"),
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ))
    ],
    leading: truf
        ? GestureDetector(
            onTap: () {
              Get.back(); // Navigate back to previous screen
            },
            child: Icon(
              Icons.arrow_back_ios, // iOS style back button icon
              color: Colors.white,
            ),
          )
        : null,
  );
}
