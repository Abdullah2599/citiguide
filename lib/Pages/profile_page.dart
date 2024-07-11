import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/bottomnavigationbar.dart';
import 'package:citiguide/controllers/ProfileSettingsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({
    Key? key,
    required this.fromPage,
    this.isNewUser = false,
  }) : super(key: key);

  final String fromPage;
  final bool isNewUser;

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final ProfileSettingsController controller =
      Get.put(ProfileSettingsController());

  @override
  void initState() {
    super.initState();
  }

  void _showChangePasswordDialog() {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newPasswordController.text ==
                    confirmPasswordController.text) {
                  controller.changePassword(newPasswordController.text);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match!')),
                  );
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 249, 245),
      appBar: app_Bar('Profile', true),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: controller
                                    .profileImageUrl.value.isNotEmpty
                                ? NetworkImage(controller.profileImageUrl.value)
                                : const AssetImage(
                                        './assets/images/default_avatar.png')
                                    as ImageProvider,
                            backgroundColor: Colors.grey,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: IconButton(
                                iconSize: 20.0,
                                icon: const Icon(Icons.add_a_photo_outlined,
                                    color: Colors.white),
                                onPressed: controller.pickImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: const Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: widget.isNewUser
                            ? TextField(
                                controller: controller.nameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  focusColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5)),
                                  fillColor: Colors.white,
                                  hintText: 'Enter your name',
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    controller.updateUserName(isNewUser: true);
                                  }
                                },
                              )
                            : Text(controller.name.isNotEmpty
                                ? controller.name
                                : 'No name set'),
                        trailing: !widget.isNewUser
                            ? IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Edit Name'),
                                        content: TextField(
                                          controller: controller.nameController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter new name',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (controller.nameController.text
                                                  .isNotEmpty) {
                                                controller.updateUserName();
                                                Navigator.of(context).pop();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Name cannot be empty!')),
                                                );
                                              }
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              )
                            : null,
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(controller.email),
                      ),
                      const Divider(),
                      const SizedBox(height: 30),
                      widget.isNewUser
                          ? ElevatedButton(
                              onPressed: () {
                                controller.updateUserName(isNewUser: true);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor:
                                    Color.fromARGB(255, 7, 206, 182),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _showChangePasswordDialog,
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor:
                                    Color.fromARGB(255, 7, 206, 182),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Change Password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    ],
                  ),
                ),
              );
      }),
      bottomNavigationBar: widget.isNewUser
          ? null
          : CustomBottomNavigationBar(
              label: widget.fromPage == 'CityScreen' ? 'Cities' : 'Attractions',
              currentIndex: 1,
              onTap: (index) {
                if (index == 0) {
                  Get.back();
                }
              },
            ),
    );
  }
}
