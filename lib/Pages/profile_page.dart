import 'package:cached_network_image/cached_network_image.dart';
import 'package:CityNavigator/Pages/Favorites.dart';
import 'package:CityNavigator/Pages/cityscreen.dart';
import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/components/reusable/appbar.dart';
import 'package:CityNavigator/components/reusable/bottomnavigationbar.dart';
import 'package:CityNavigator/controllers/ProfileSettingsController.dart';
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

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 249, 245),
      appBar: widget.isNewUser
          ? AppBar(
              title: const Text(
                'Complete Profile Setup',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: ColorTheme.primaryColor,
            )
          : app_Bar('Profile', true, 'Profile','',),
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
                        
                        title: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
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
                                icon: const Icon(Icons.edit, size:  17,),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        title: const Text('Edit Name'),
                                        content: TextField(
                                          controller: controller.nameController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            focusColor: Colors.white,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            fillColor: Colors.white,
                                            hintText: 'Enter new name',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.grey[
                                                  200], // Example background color
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 24),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: const Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors.black87)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (controller.nameController.text
                                                  .isNotEmpty) {
                                                controller.updateUserName();
                                                Navigator.of(context).pop();
                                              } else {
                                                Get.snackbar(
                                                  'Enter your name',
                                                  'Name cannot be empty!',
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          160, 81, 160, 136),
                                                  barBlur: 3.0,
                                                  colorText: Colors.white,
                                                  borderRadius: 5,
                                                  borderWidth: 50,
                                                  dismissDirection:
                                                      DismissDirection
                                                          .horizontal,
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 5,
                                              backgroundColor: ColorTheme
                                                  .primaryColor, // Your primary color
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 24),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: const Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors
                                                      .white), // Example text color
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              )
                            : null,
                      ),
                      const Divider( color: Color.fromARGB(255, 7, 206, 182),thickness: 0.5,),
                      ListTile(
                        title: const Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(controller.email),
                      ),
                      const Divider( color: Color.fromARGB(255, 7, 206, 182), thickness: 0.5,),
                      const SizedBox(height: 30),
                      widget.isNewUser
                          ? ElevatedButton(
                              onPressed: () {
                                controller.updateUserName(isNewUser: true);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor:
                                    const Color.fromARGB(255, 7, 206, 182),
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
                          : Container(),
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
                      ? Get.to(() => const FavoritesScreen())
                      : '';
                }
                if (index == 0) {
                  Get.to(() => CityScreen());
                }
                if (index == 2) {
                  Get.to(() => const FavoritesScreen());
                }
                if (index == 1) {
                  widget.fromPage == 'Homepage' ? Get.back() : '';
                }
              },
            ),
    );
  }

 
}
