import 'package:CityNavigator/Pages/Favorites.dart';
import 'package:CityNavigator/Pages/cityscreen.dart';
import 'package:CityNavigator/Pages/maindetails.dart';
import 'package:CityNavigator/Pages/profile_page.dart';
import 'package:CityNavigator/components/reusable/appbar.dart';
import 'package:CityNavigator/components/reusable/bottomnavigationbar.dart';
import 'package:CityNavigator/components/reusable/categorybuttons.dart';
import 'package:CityNavigator/components/reusable/places_tile.dart';
import 'package:CityNavigator/controllers/DataController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class HomePage extends StatelessWidget {

  HomePage({super.key, this.ciity});

  final dynamic ciity;
  final RxString _selectedCategory = 'All'.obs;
  final List<String> categories = [
    "All",
    "Popular Attractions",
    "Hotels",
    "Restaurants",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {
    final Datacontroller datacontroller =
        Get.put(Datacontroller(city: ciity, category: _selectedCategory.value));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 244, 248),
      appBar: app_Bar(ciity, true, 'Home', ciity,),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FocusScope(
          node: FocusScopeNode(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 233, 248, 245),
                    Color.fromARGB(255, 236, 249, 245),
                  ]),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Obx(
                    () => TextField(
                      controller: datacontroller.searchController,
                      focusNode: datacontroller.searchFocusNode,
                      onChanged: (query) {
                        datacontroller.searchRecords(query);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30)),
                        contentPadding: const EdgeInsets.all(20),
                        hintText: _selectedCategory.value == 'All'
                            ? 'Search Places'
                            : 'Search ${_selectedCategory.value}',
                        suffixIcon: IconButton(
                          onPressed: () {
                            datacontroller.clearSearch();
                          },
                          icon: Obx(() {
                            return Icon(
                              datacontroller.isSearching.value
                                  ? Icons.clear
                                  : Icons.search,
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: categories
                        .map((category) => _categoryButton(category))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Ratings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 30,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_upward, size: 18.0),
                          onPressed: () {
                            datacontroller.sortByRating(ascending: false);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_downward, size: 18.0),
                          onPressed: () {
                            datacontroller.sortByRating(ascending: true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () {
                      if (datacontroller.isLoading.value) {
                        return const Center(
                            child: GFLoader(
                                size: GFSize.LARGE,
                                type: GFLoaderType.square,
                                loaderColorOne:
                                    Color.fromARGB(255, 0, 250, 217),
                                loaderColorTwo:
                                    Color.fromARGB(255, 123, 255, 237),
                                loaderColorThree:
                                    Color.fromARGB(255, 201, 255, 248)));
                      } else if (datacontroller.filteredRecords.isEmpty) {
                        return const Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      } else {
                        // Show list of places
                        return ListView.builder(
                          itemCount: datacontroller.filteredRecords.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Get.to(() => TilesDetails(
                                      placeData:
                                          datacontroller.filteredRecords[index],
                                      placeId: datacontroller
                                          .filteredRecords[index]['id'],
                                    ));
                              },
                              child: PlacesTile(
                                  name: datacontroller.filteredRecords[index]
                                          ["title"]
                                      .toString(),
                                  city: datacontroller.filteredRecords[index]
                                          ["city"]
                                      .toString(),
                                  rating: datacontroller.filteredRecords[index]
                                          ["averageRating"] ??
                                      0.0,
                                  imagelink: datacontroller
                                      .filteredRecords[index]["imageurl"]
                                      .toString()),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          citySelected: false,
          currentIndex: 1,
          label: 'Attractions',
          onTap: (index) {
            if (index == 3) {
              Get.to(() => const ProfileSettingsPage(fromPage: 'Homepage'));
            }
            if (index == 0) {
              Get.off(() => CityScreen());
            }
            if (index == 2) {
              Get.to(() => const FavoritesScreen(
                    fromPage: 'Homepage',
                  ));
            }
          }),
     
    );
  }

  Widget _categoryButton(String category) {
    return Obx(
      () => myButton(
        Function: () {
          _selectedCategory.value = category;
          Datacontroller datacontroller = Get.find();
          datacontroller.clearSearch();
          datacontroller.fetchData(
              city: datacontroller.city, category: category);
        },
        buttontext: category,
        isActive: _selectedCategory.value == category,
      ),
    );
  }
}
