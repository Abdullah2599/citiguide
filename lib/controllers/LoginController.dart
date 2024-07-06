import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  late TextEditingController emailAddress = new TextEditingController();
  late TextEditingController password = new TextEditingController();

  // final List<GlobalObjectKey<FormState>> LoginformKey =
  //     List.generate(10, (index) => GlobalObjectKey<FormState>(index));
  final GlobalKey<FormState> LoginFormKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  // final RxBool loader = false.obs;

  void signInWithEmailAndPassword() async {
    try {
      btnController.start();
      // loader.value = true;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      Get.snackbar('Success', 'Login Success');
      btnController.success();
      emailAddress.clear();
      password.clear();
      // loader.value = false;
      Get.off(CityScreen());
    } on FirebaseAuthException catch (e) {
      //  loader.value = false;
      btnController.reset();
      if (e.code == 'invalid-credential') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      }
    }
  }
}
