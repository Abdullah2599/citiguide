import 'package:citiguide/Pages/cityscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  late TextEditingController emailAddress = TextEditingController();
  late TextEditingController password = TextEditingController();

  final List<GlobalObjectKey<FormState>> LoginformKey =
      List.generate(10, (index) => GlobalObjectKey<FormState>(index));

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
