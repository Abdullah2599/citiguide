import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/components/reusable/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

app_Bar(String text) {
  return AppBar(
    // automaticallyImplyLeading: false,
    title: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    surfaceTintColor: Colors.transparent,
    backgroundColor: const Color.fromARGB(255, 17, 10, 41),
    actions: [
      IconButton(
          onPressed: () {
            // Get.defaultDialog(

            //     title: "Alert!",
            //     content: Text("Do you want to Logout?"),
            //     actions: [
            //       materialButton(
            //           function: () {
            //             Get.snackbar("Logout", "Logout successfully");
            //             Get.offAll(Login());

            //           },
            //           btnText: "yes",
            //           btnColor: ColorTheme.primaryColor),
            //       materialButton(
            //           function: () {
            //             Get.back();
            //           },
            //           btnText: "No",
            //           btnColor: Colors.red)
            //     ]);
            Get.defaultDialog(
                onConfirm: () => {
                      Get.snackbar("Logout", "Logout successfully"),
                      Get.to(const LoginPage())
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
                    const Text("Are you sure to logout!"),
                  ],
                ));
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ))
    ],
  );
}
