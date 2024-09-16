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

  @override
  Widget build(BuildContext context) {
    // Function to show exit confirmation dialog
    Future<bool> showExitConfirmationDialog() async {
      return await Get.defaultDialog(
        buttonColor: ColorTheme.primaryColor,
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
          Get.back(); // Navigate back twice to exit the app
        },
        onCancel: () => Get.back(),
        title: "Exit",
        content: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Are you sure you want to exit?"),
          ],
        ),
      );
    }

    // Register callback for back button press
    // ignore: deprecated_member_use
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      bool canPop = await showExitConfirmationDialog();
      return canPop;
    });

    return Scaffold(
      appBar: app_Bar('Cities', false, 'Cities',''),
      body: GestureDetector(
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
                            loaderColorTwo: Color.fromARGB(255, 123, 255, 237),
                            loaderColorThree:
                                Color.fromARGB(255, 201, 255, 248)));
                  } else {
                    //sort the cities alphabetically
                    List sortedCities = List.from(cityController.filteredCities)
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
                                    ciity:
                                        sortedCities[index]["cname"]! as String,
                                  ));
                            },
                            child: CityCard(
                              cityimg: sortedCities[index]["cimg"].toString(),
                              cityname: sortedCities[index]["cname"].toString(),
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
