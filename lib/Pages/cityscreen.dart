import 'package:cached_network_image/cached_network_image.dart';
import 'package:citiguide/Pages/Favorites.dart';
import 'package:citiguide/Pages/homepage.dart';
import 'package:citiguide/Pages/profile_page.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/bottomnavigationbar.dart';
import 'package:citiguide/components/reusable/citycard.dart';
import 'package:citiguide/controllers/CityController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityScreen extends StatelessWidget {
  CityScreen({super.key});

  final CityController cityController = Get.put(CityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_Bar('Cities', false),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
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
                    contentPadding: EdgeInsets.all(20),
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
                  //sort the cities alphabetically
                  List sortedCities = List.from(cityController.filteredCities)
                    ..sort((a, b) =>
                        (a["cname"] as String).compareTo(b["cname"] as String));

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
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        label: 'Cities',
        showLikeButton: true, // No like button on CityScreen
        onTap: (index) {
          if (index == 2) {
            Get.to(() => ProfileSettingsPage(fromPage: 'CityScreen'));
          }
          if (index == 1) {
            Get.to(() => FavoritesScreen());
          }
        },
      ),
    );
  }
}

Future<void> bottomSheet(BuildContext context, Map<dynamic, dynamic> cityData) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
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
        padding: EdgeInsets.fromLTRB(22.0, 5, 22.0, 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
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
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: cityData["cimg"].toString(),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              cityData["cname"].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 8),
            Text(
              cityData["cdesc"] ?? 'No description available',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}
