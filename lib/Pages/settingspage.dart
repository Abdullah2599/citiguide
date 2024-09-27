import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/controllers/ProfileSettingsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsUI extends StatelessWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
         leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ),  

      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                onTap: _showDeleteAccountDialog,
                  tileColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textColor: Colors.black,
                  leading: Icon(Icons.delete, color: Colors.white),
                  title: Text("Delete Account",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),         
                ),
                SizedBox(height: 10),
                ListTile(
                  onTap: _showChangePasswordDialog,
                  tileColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textColor: Colors.black,
                  leading: Icon(Icons.change_circle, color: Colors.white),
                  title: Text("Change Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),         
                ),
                //  ListTile(
                //   tileColor: Colors.red,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   textColor: Colors.black,
                //   leading: Icon(Icons.delete, color: Colors.white),
                //   title: Text("Delete Account",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),         
                // ), 
            ],
          ),
        )
      ),

    );
  }

  void _showDeleteAccountDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Get.defaultDialog(
      radius: 5,
      title: "Delete Account",
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Are you sure you want to delete your account? This action cannot be undone.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            final email = emailController.text;
            final password = passwordController.text;

            if (email.isNotEmpty && password.isNotEmpty) {
              ProfileSettingsController controller = Get.put(ProfileSettingsController());
              await controller.deleteAccount(email, password);
              Get.back(); // Close the dialog
            } else {
              Get.snackbar(
                'Error',
                'Please enter email and password.',
                backgroundColor: const Color.fromARGB(160, 81, 160, 136),
                barBlur: 3.0,
                colorText: Colors.white,
                borderRadius: 5,
                borderWidth: 50,
                dismissDirection: DismissDirection.horizontal,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: ColorTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }


  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 30),
      title: 'Change Password',
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            14.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Current Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'New Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      radius: 5,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200], // Example background color
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black87), // Example text color
          ),
        ),
        const SizedBox(width: 8), // Optional spacing between buttons
        ElevatedButton(
          onPressed: () {
            if (newPasswordController.text == confirmPasswordController.text) {
                ProfileSettingsController controller = Get.put(ProfileSettingsController());
              controller
              .changePassword(
                currentPasswordController.text,
                newPasswordController.text,
              );
              Get.back();
            } else {
              Get.snackbar(
                'Error',
                'Passwords do not match!',
                backgroundColor: const Color.fromARGB(160, 81, 160, 136),
                colorText: Colors.white,
                borderRadius: 5,
                borderWidth: 50,
                dismissDirection: DismissDirection.horizontal,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: ColorTheme.primaryColor, // Your primary color
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            'Change',
            style: TextStyle(color: Colors.white), // Example text color
          ),
        ),
      ],
    );
  }
}