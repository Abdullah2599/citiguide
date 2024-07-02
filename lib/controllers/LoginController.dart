import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late TextEditingController emailAddress = new TextEditingController();
  late TextEditingController password = new TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  void signInWithEmailAndPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);

      Get.snackbar('Success', 'Login Success');
      emailAddress.clear();
      password.clear();
      Get.to(CityScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      }
    }
  }
}
