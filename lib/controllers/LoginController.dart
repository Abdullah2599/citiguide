import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  late TextEditingController emailAddress = new TextEditingController();
  late TextEditingController password = new TextEditingController();

  // final List<GlobalObjectKey<FormState>> LoginformKey =
  //     List.generate(10, (index) => GlobalObjectKey<FormState>(index));
  final GlobalKey<FormState> LoginFormKey = GlobalKey<FormState>();
  final RxBool loader = false.obs;

  void signInWithEmailAndPassword() async {
    try {
      loader.value = true;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      Get.snackbar('Success', 'Login Success');
      emailAddress.clear();
      password.clear();
      loader.value = false;
      Get.to(CityScreen());
    } on FirebaseAuthException catch (e) {
       loader.value = false;
      if (e.code == 'invalid-credential') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      }
    }
  }
}
