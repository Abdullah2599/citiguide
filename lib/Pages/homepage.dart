import 'package:citiguide/Golobal%20Loader/boxrotation.dart';
import 'package:citiguide/Pages/Favorites.dart';
import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/maindetails.dart';
import 'package:citiguide/Pages/profile_page.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/bottomnavigationbar.dart';
import 'package:citiguide/components/reusable/categorybuttons.dart';
import 'package:citiguide/components/reusable/places_tile.dart';
import 'package:citiguide/components/reusable/textbutton.dart';
import 'package:citiguide/controllers/DataController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/types/gf_loader_type.dart';

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
      backgroundColor: Color.fromARGB(255, 230, 244, 248),
      appBar: app_Bar(ciity, true, 'Home'),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FocusScope(
          node: FocusScopeNode(),
          child: Container(
            decoration: BoxDecoration(
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
                        contentPadding: EdgeInsets.all(20),
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
                      Text(
                        'Ratings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 30,
                        child: IconButton(
                          icon: Icon(Icons.arrow_upward, size: 18.0),
                          onPressed: () {
                            datacontroller.sortByRating(ascending: false);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: IconButton(
                          icon: Icon(Icons.arrow_downward, size: 18.0),
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
                        return Center(
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
                          physics: BouncingScrollPhysics(),
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
              Get.to(() => ProfileSettingsPage(fromPage: 'Homepage'));
            }
            if (index == 0) {
              Get.to(() => CityScreen());
            }
            if (index == 2) {
              Get.to(() => FavoritesScreen(
                    fromPage: 'Homepage',
                  ));
            }
          }),
    );
  }

  // if (index == 0) {
  //   widget.fromPage == 'CityScreen' ? Get.back() : '';
  // }
  // if (index == 0) {
  //   widget.fromPage == 'Favorite'
  //       ? Get.to(() => FavoritesScreen())
  //       : '';
  // }
  // if (index == 0) {
  //   Get.to(() => CityScreen());
  // }
  // if (index == 2) {
  //   Get.to(() => FavoritesScreen());
  // }

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
