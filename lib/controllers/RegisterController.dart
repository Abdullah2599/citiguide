import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/Pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  late TextEditingController emailAddress = new TextEditingController();
  late TextEditingController password = new TextEditingController();

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  void createUserWithEmailAndPassword() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress.text,
        password: password.text,
      );

      Get.snackbar("Success", "Account Created");
      emailAddress.clear();
      password.clear();
      Get.off(() => ProfileSettingsPage(
            fromPage: 'CitiesScreen',
            isNewUser: true,
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Weak Password", 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Email Already Exists",
            'The account already exists for that email.');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
