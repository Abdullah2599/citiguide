import 'package:citiguide/Pages/cityscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late TextEditingController emailAddress = TextEditingController();
  late TextEditingController password = TextEditingController();

  final GlobalKey<FormState> LoginFormKey = GlobalKey<FormState>();

  final RxBool loader = false.obs;

  void signInWithEmailAndPassword() async {
    try {
      loader.value = true;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress.text,
        password: password.text,
      );

      Get.snackbar(
        'Success',
        'Login Success',
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
      Get.offAll(() => CityScreen());
    } on FirebaseAuthException catch (e) {
      loader.value = false;

      // Check for specific FirebaseAuthException codes
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Error',
          'No user found for that email.',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
        emailAddress.clear();
        password.clear();
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'Error',
          'Wrong password provided for that user.',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
        // Only clear the password field on wrong-password error

        password.clear();
      } else if (e.code == 'user-disabled') {
        Get.snackbar(
          'Error',
          'This user account has been disabled.',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
        emailAddress.clear();
        password.clear();
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          'Error',
          'The email address is not valid.',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
        emailAddress.clear();
      } else {
        // Handle other possible errors
        Get.snackbar(
          'Error',
          'An unexpected error occurred. Please try again later.',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
        emailAddress.clear();
        password.clear();
      }
    } catch (e) {
      // Catch any other errors that are not FirebaseAuthExceptions
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again later.',
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
    }
  }

  static void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginPage());
      Get.snackbar(
        "Logout",
        "Logout successfully",
        backgroundColor: const Color.fromARGB(160, 81, 160, 136),
        barBlur: 3.0,
        colorText: Colors.white,
        borderRadius: 5,
        borderWidth: 50,
        dismissDirection: DismissDirection.horizontal,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to sign out: $e",
        backgroundColor: const Color.fromARGB(160, 81, 160, 136),
        barBlur: 3.0,
        colorText: Colors.white,
        borderRadius: 5,
        borderWidth: 50,
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
