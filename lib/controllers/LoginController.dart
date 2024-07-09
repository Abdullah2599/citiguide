import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginController extends GetxController {


  late TextEditingController emailAddress = new TextEditingController();
  late TextEditingController password = new TextEditingController();


  final GlobalKey<FormState> LoginFormKey = GlobalKey<FormState>();
 
    final RxBool loader = false.obs;

  void signInWithEmailAndPassword() async {
    try {
      
       loader.value = true;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      
      Get.snackbar('Success', 'Login Success',
          backgroundColor: Color.fromARGB(167, 0, 0, 0),
          barBlur: 2.0,
          colorText: Colors.white);
      emailAddress.clear();
      password.clear();
       loader.value = false;
      Get.off(CityScreen());
    } on FirebaseAuthException catch (e) {
      loader.value = false;
     
      if (e.code == 'invalid-credential') {
        Get.snackbar('Error', 'No user found for that email.',
            backgroundColor: const Color.fromARGB(167, 0, 0, 0),
            barBlur: 15.0,
            colorText: Colors.white);
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.',
            backgroundColor: const Color.fromARGB(167, 0, 0, 0),
            barBlur: 15.0,
            colorText: Colors.white);
      }
    }
  }
}
