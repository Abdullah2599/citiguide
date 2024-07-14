import 'dart:io';
import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/controllers/LoginController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController nameController = TextEditingController();
  final RxString profileImageUrl = ''.obs;
  final RxBool isLoading = false.obs;

  late String email;
  String name = '';

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void onInit() {
    super.onInit();
    email = _auth.currentUser?.email ?? '';
    if (email.isNotEmpty) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await _firestore.collection('users').doc(email).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        name = userData?['name'] ?? '';
        profileImageUrl.value = userData?['image'] ?? '';
        nameController.text = name;
      } else {
        // create a new document with the user data if it doesn't exist
        await _firestore.collection('users').doc(email).set({
          'name': name,
          'image': profileImageUrl.value,
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }

  Future<void> updateUserName({bool isNewUser = false}) async {
    final newName = nameController.text.trim();
    if (newName.isNotEmpty) {
      isLoading.value = true;
      try {
        await _firestore
            .collection('users')
            .doc(email)
            .update({'name': newName});
        name = newName;
        Get.snackbar('Success', 'Name updated successfully');
        if (isNewUser) {
          Get.offAll(() =>
              CityScreen()); // navigate to the next page after success only if new user
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to update name: $e');
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Error', 'Name cannot be empty.');
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User is not authenticated.');
        return;
      }

      // Reauthenticate user with current password
      final credential =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(newPassword);

      Get.snackbar('Success', 'Password changed successfully');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', 'Failed to change password: $e',
          duration: Duration(seconds: 5));
    } catch (e) {
      Get.snackbar('Error', 'Failed to change password: $e',
          duration: Duration(seconds: 5));
    }
  }

  Future<void> uploadProfileImage() async {
    if (_imageFile == null) {
      Get.snackbar('Error', 'No image selected.');
      return;
    }

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User is not authenticated.');
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user.uid}.jpg');
      final uploadTask = storageRef.putFile(File(_imageFile!.path));

      isLoading.value = true;
      await uploadTask.whenComplete(() async {
        final downloadUrl = await storageRef.getDownloadURL();
        await _firestore
            .collection('users')
            .doc(user.email)
            .update({'image': downloadUrl});
        profileImageUrl.value = downloadUrl;
        Get.snackbar('Success', 'Profile image updated successfully');
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to upload image: $error');
      }).whenComplete(() {
        isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = pickedFile;
        await uploadProfileImage();
      } else {
        Get.snackbar('Error', 'No image selected.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User is not authenticated.');
        return;
      }

      // Delete user data from Firestore
      await _firestore.collection('users').doc(email).delete();

      // Delete user profile image from Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user.uid}.jpg');
      await storageRef.delete();

      // Delete the user account
      await user.delete();
      LoginController.signOut();
      // Optionally navigate to another page after account deletion
      Get.offAll(() => LoginPage());

      Get.snackbar('Success', 'Account deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account: $e');
    }
  }
}
