import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/controllers/LoginController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:citiguide/components/reusable/sizedbox.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

// app_Bar(String text, truf) {
//   return AppBar(
//     automaticallyImplyLeading: truf,
//     // leading: I,
//     // icon: Icon(Icons.arrow_back_ios)),
//     clipBehavior: Clip.hardEdge,
//     foregroundColor: Colors.white,
//     title: Text(
//       text,
//       style: TextStyle(color: Colors.white),
//     ),
//     surfaceTintColor: Colors.transparent,
//     backgroundColor: Color.fromARGB(255, 17, 10, 41),
//     actions: [
//       IconButton(
//           onPressed: () {
//             // Get.defaultDialog(

//             //     title: "Alert!",
//             //     content: Text("Do you want to Logout?"),
//             //     actions: [
//             //       materialButton(
//             //           function: () {
//             //             Get.snackbar("Logout", "Logout successfully");
//             //             Get.offAll(Login());

//             //           },
//             //           btnText: "yes",
//             //           btnColor: ColorTheme.primaryColor),
//             //       materialButton(
//             //           function: () {
//             //             Get.back();
//             //           },
//             //           btnText: "No",
//             //           btnColor: Colors.red)
//             //     ]);
//             Get.defaultDialog(
//               onConfirm: LoginController.signOut();
//                 // onConfirm: () async {
//                 //   await FirebaseAuth.instance.signOut();
//                 //   Get.snackbar("Logout", "Logout successfully",
//                 //       backgroundColor: const Color.fromARGB(167, 0, 0, 0),
//                 //       barBlur: 10.0,
//                 //       colorText: Colors.white);

//                 //   Get.to(LoginPage());
//                // },
//                 onCancel: () => {Get.back()},
//                 title: "Logout",
//                 content: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.question_mark,
//                       size: 40,
//                     ),
//                     sizedBox(),
//                     Text("Are you sure to logout!"),
//                   ],
//                 ));
//           },
//           icon: const Icon(
//             Icons.logout,
//             color: Colors.white,
//           ))
//     ],
//   );
// }

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
    backgroundColor: Color.fromARGB(255, 17, 10, 41),
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
