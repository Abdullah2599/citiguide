import 'package:cached_network_image/cached_network_image.dart';

import 'package:citiguide/Pages/Favorites.dart';
import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/bottomnavigationbar.dart';
import 'package:citiguide/controllers/ProfileSettingsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_loader_type.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({
    super.key,
    required this.fromPage,
    this.isNewUser = false,
  });

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

  void _showDeleteAccountDialog() {
    Get.defaultDialog(
      buttonColor: ColorTheme.primaryColor,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await controller.deleteAccount();
        // Navigator.of(context).pop();
      },
      onCancel: () {
        Navigator.pop(context);
      },
      title: "Delete Account",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 249, 245),
      appBar: app_Bar('Profile', true, ''),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(
                child: GFLoader(
                    size: GFSize.LARGE,
                    type: GFLoaderType.square,
                    loaderColorOne: Color.fromARGB(255, 0, 250, 217),
                    loaderColorTwo: Color.fromARGB(255, 123, 255, 237),
                    loaderColorThree: Color.fromARGB(255, 201, 255, 248)))
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
                                ? CachedNetworkImageProvider(
                                    controller.profileImageUrl.value)
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
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
                          : Column(
                              children: [
                                ElevatedButton(
                                  onPressed: _showChangePasswordDialog,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor:
                                        Color.fromARGB(255, 7, 206, 182),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
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
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _showDeleteAccountDialog,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 45, 45),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 48, vertical: 15),
                                  ),
                                  child: const Text(
                                    'Delete Account',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
      }),
      bottomNavigationBar: widget.isNewUser
          ? null
          : CustomBottomNavigationBar(
              citySelected: true,
              label: widget.fromPage == 'CityScreen' ? 'Cities' : 'Attractions',
              currentIndex: 3,
              onTap: (index) {
                if (index == 0) {
                  widget.fromPage == 'CityScreen' ? Get.back() : '';
                }
                if (index == 0) {
                  widget.fromPage == 'Favorite'
                      ? Get.to(() => FavoritesScreen())
                      : '';
                }
                if (index == 0) {
                  Get.to(() => CityScreen());
                }
                if (index == 2) {
                  Get.to(() => FavoritesScreen());
                }
                if (index == 1) {
                  widget.fromPage == 'Homepage' ? Get.back() : '';
                }
              },
            ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Current Password'),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newPasswordController.text ==
                    confirmPasswordController.text) {
                  controller.changePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match!')),
                  );
                }
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }
}
