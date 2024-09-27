import 'package:CityNavigator/Pages/notificationsscreen.dart';
import 'package:CityNavigator/Pages/orderhistory.dart';
import 'package:CityNavigator/Pages/privacypolicy.dart';
import 'package:CityNavigator/Pages/requestplace.dart';
import 'package:CityNavigator/Pages/settingspage.dart';
import 'package:CityNavigator/components/reusable/customdrawerlisttile.dart';
import 'package:CityNavigator/controllers/LoginController.dart';
import 'package:CityNavigator/controllers/ProfileSettingsController.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:CityNavigator/Pages/Favorites.dart';
import 'package:CityNavigator/Pages/homepage.dart';
import 'package:CityNavigator/Pages/profile_page.dart';
import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/components/reusable/appbar.dart';
import 'package:CityNavigator/components/reusable/bottomnavigationbar.dart';
import 'package:CityNavigator/components/reusable/citycard.dart';
import 'package:CityNavigator/controllers/CityController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_loader_type.dart';

class CityScreen extends StatelessWidget {
  CityScreen({super.key});

  final CityController cityController = Get.put(CityController());
  final ProfileSettingsController profileSettingsController =
      Get.put(ProfileSettingsController());

  @override
  Widget build(BuildContext context) {
    // Function to show exit confirmation dialog
    // Future<bool> showExitConfirmationDialog() async {
    //   return await Get.defaultDialog(
    //     buttonColor: ColorTheme.primaryColor,
    //     confirmTextColor: Colors.white,
    //     onConfirm: () {
    //       Get.back();
    //       Get.back();
    //       SystemNavigator.pop();
    //       // Navigate back twice to exit the app
    //     },
    //     onCancel: () => Get.back(),
    //     title: "Exit",
    //     content: const Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text("Are you sure you want to exit?"),
    //       ],
    //     ),
    //   );
    // }

    // // Register callback for back button press
    // // ignore: deprecated_member_use
    // ModalRoute.of(context)?.addScopedWillPopCallback(() async {
    //   bool canPop = await showExitConfirmationDialog();
    //   return canPop;
    // });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: ColorTheme.primaryColor,
        title: const Text('Cities',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Get.to(() => const NotificationsScreen());
              }),
        ],
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          Future.delayed(const Duration(milliseconds: 100), () {
            HapticFeedback.mediumImpact();
          });
          final NavigatorState navigator = Navigator.of(context);
          final bool? shouldPop = await Get.defaultDialog(
            buttonColor: ColorTheme.primaryColor,
            confirmTextColor: Colors.white,
            textConfirm: 'Yes',
            onConfirm: () {
              Get.back();
              SystemNavigator.pop();
            },
            onCancel: () => Get.back(
              result: false,
            ),
            title: "Exit",
            content: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Are you sure you want to exit?"),
              ],
            ),
          );
          if (shouldPop ?? false) {
            navigator.pop();
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color.fromARGB(255, 233, 248, 245),
                  Color.fromARGB(255, 236, 249, 245),
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    onChanged: (value) {
                      cityController.filterCities();
                    },
                    controller: cityController.searchController,
                    focusNode: cityController.searchFocusNode,
                    autofocus: false,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                      hintText: 'Search Cities',
                      suffixIcon: IconButton(
                        onPressed: () {
                          cityController.clearSearch();
                        },
                        icon: Obx(() {
                          return Icon(
                            cityController.isSearching.value
                                ? Icons.clear
                                : Icons.search,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (cityController.isLoading.value) {
                      // Show loader while loading data
                      return const Center(
                          child: GFLoader(
                              size: GFSize.LARGE,
                              type: GFLoaderType.square,
                              loaderColorOne: Color.fromARGB(255, 0, 250, 217),
                              loaderColorTwo:
                                  Color.fromARGB(255, 123, 255, 237),
                              loaderColorThree:
                                  Color.fromARGB(255, 201, 255, 248)));
                    } else {
                      //sort the cities alphabetically
                      List sortedCities =
                          List.from(cityController.filteredCities)
                            ..sort((a, b) => (a["cname"] as String)
                                .compareTo(b["cname"] as String));

                      return GridView.builder(
                        itemCount: sortedCities.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onLongPress: () {
                                bottomSheet(context, sortedCities[index]);
                                HapticFeedback.lightImpact();
                              },
                              onTap: () {
                                cityController.searchFocusNode.unfocus();
                                Get.to(() => HomePage(
                                      ciity: sortedCities[index]["cname"]!
                                          as String,
                                    ));
                              },
                              child: CityCard(
                                cityimg: sortedCities[index]["cimg"].toString(),
                                cityname:
                                    sortedCities[index]["cname"].toString(),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: ColorTheme.lightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                  color: ColorTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: profileSettingsController
                                  .profileImageUrl.value.isNotEmpty
                              ? CachedNetworkImageProvider(
                                  profileSettingsController.profileImageUrl.value)
                              : const AssetImage(
                                      './assets/images/default_avatar.png')
                                  as ImageProvider,
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileSettingsController.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              profileSettingsController.email,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
            customDrawerlistTile(
                title: "Profile",
                icon: Icons.person,
                onTap: () => Get.to(() => ProfileSettingsPage(
                      fromPage: 'CityScreen',
                    ))),
            customDrawerlistTile(
                title: "Notifications",
                icon: Icons.notifications,
                onTap: () => Get.to(() => NotificationsScreen())),
             customDrawerlistTile(
                title: "Order History",
                icon: Icons.notifications,
                onTap: () => Get.to(() => Orderhistory())),    
            customDrawerlistTile(
                title: "Favorites",
                icon: Icons.favorite,
                onTap: () => Get.to(() => FavoritesScreen())),
             customDrawerlistTile(
                title: "Settings",
                icon: Icons.settings,
                onTap: () => Get.to(() => SettingsUI())),
            customDrawerlistTile(
                title: "Request Places",
                icon: Icons.wallet_outlined,
                onTap: () => Get.to(() => Requestplace())),
            customDrawerlistTile(
                title: "Privacy Policy",
                icon: Icons.policy,
                onTap: () => Get.to(() => Privacypolicy())),
            customDrawerlistTile(
                title: "Logout",
                icon: Icons.logout,
                onTap: () {
                  Get.defaultDialog(
                    radius: 5,
                    title: "Log out",
                    content: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Are you sure you want to logout?"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Colors.grey[200], // Example background color
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black87), // Example text color
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Optional spacing between buttons
                      ElevatedButton(
                        onPressed: () {
                          LoginController.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor:
                              ColorTheme.primaryColor, // Your primary color
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Log out',
                          style: TextStyle(
                              color: Colors.white), // Example text color
                        ),
                      ),
                    ],
                  );
                }),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        citySelected: false,
        currentIndex: 0,
        label: 'Cities',
        onTap: (index) {
          if (index == 1) {
            // Get.to(() => ProfileSettingsPage(fromPage: 'CityScreen'));
          }
          // if (index == 1) {
          //   Get.to(() => FavoritesScreen());
          // }
          if (index == 2) {
            Get.to(() => const FavoritesScreen(
                  fromPage: 'CityScreen',
                ));
          }
          if (index == 3) {
            Get.to(() => const ProfileSettingsPage(fromPage: 'CityScreen'));
          }
        },
      ),
    );
  }
}

Future<void> bottomSheet(BuildContext context, Map<dynamic, dynamic> cityData) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    elevation: 10,
    showDragHandle: true,
    enableDrag: true,
    builder: (context) => SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(22.0, 5, 22.0, 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 18,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: cityData["cimg"].toString(),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              cityData["cname"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cityData["cdesc"] ?? 'No description available',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}
