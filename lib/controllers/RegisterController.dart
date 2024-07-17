import 'package:citiguide/Pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  late TextEditingController emailAddress = new TextEditingController();
  late TextEditingController password = new TextEditingController();

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final RxBool loader = false.obs;

  void createUserWithEmailAndPassword() async {
    try {
      loader.value = true;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress.text,
        password: password.text,
      );

      Get.snackbar(
        "Success",
        "Account Created",
        backgroundColor: const Color.fromARGB(160, 81, 160, 136),
        barBlur: 3.0,
        colorText: Colors.white,
        borderRadius: 5,
        borderWidth: 50,
        dismissDirection: DismissDirection.horizontal,
      );
      emailAddress.clear();
      password.clear();
      loader.value = false;
      Get.offAll(() => const ProfileSettingsPage(
            fromPage: 'CitiesScreen',
            isNewUser: true,
          ));
    } on FirebaseAuthException catch (e) {
      loader.value = false;
      if (e.code == 'weak-password') {
        Get.snackbar(
          "Weak Password",
          'The password provided is too weak.',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          "Email Already Exists",
          'The account already exists for that email.',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
