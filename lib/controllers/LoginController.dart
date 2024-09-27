import 'package:CityNavigator/Pages/cityscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:CityNavigator/Pages/loginpage.dart';
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

  void signOut() async {
    try {
       await deleteUserToken();
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

  Future<void> deleteUserToken() async {
    // Get the currently logged-in user
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the Firestore collection
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.email);

      try {
        // Update the document to remove the token field
        await userRef.update({
          'token': FieldValue.delete(),
        });
        print('Token deleted successfully for user: ${user.email}');
      } catch (e) {
        print('Error deleting token: $e');
      }
    } else {
      print('No user is currently logged in.');
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
