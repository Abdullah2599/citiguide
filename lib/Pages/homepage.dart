import 'package:citiguide/Pages/maindetails.dart';
import 'package:citiguide/Pages/profile_page.dart';
import 'package:citiguide/Pages/tourist_details.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/bottomnavigationbar.dart';
import 'package:citiguide/components/reusable/categorybuttons.dart';
import 'package:citiguide/components/reusable/places_tile.dart';
import 'package:citiguide/components/reusable/textbutton.dart';
import 'package:citiguide/controllers/DataController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, this.ciity});

  final dynamic ciity;
  final Datacontroller datacontroller = Get.put(Datacontroller());
  final RxString _selectedCategory = 'Popular Attractions'.obs;
  final List<String> categories = [
    "Popular Attractions",
    "Hotels",
    "Restaurants",
    "Others"
  ];
  final ScrollController _scrollController = ScrollController();
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    datacontroller.fetchData(city: ciity, category: _selectedCategory.value);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 244, 248),
      appBar: app_Bar(ciity, true),
      body: Container(
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
              child: TextField(
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
                  hintText: 'Search Places and Attractions',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 30, // Adjust the width as needed
                    child: IconButton(
                      icon: Icon(Icons.arrow_upward, size: 18.0),
                      onPressed: () {
                        datacontroller.sortByRating(ascending: false);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30, // Adjust the width as needed
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
                () => PageStorage(
                  bucket: _bucket,
                  child: ListView.builder(
                    key: PageStorageKey<String>('homePageList'),
                    controller: _scrollController,
                    itemCount: datacontroller.filteredRecords.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Store the scroll position
                          double scrollPosition =
                              _scrollController.position.pixels;

                          Get.to(() => TilesDetails(
                                    placeData:
                                        datacontroller.filteredRecords[index],
                                    placeId: datacontroller
                                        .filteredRecords[index]['id'],
                                  ))!
                              .then((value) {
                            datacontroller.fetchData(
                              city: ciity,
                              category: _selectedCategory.value,
                            );
                            // Restore the scroll position
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollController.jumpTo(scrollPosition);
                            });
                          });
                        },
                        child: PlacesTile(
                            name: datacontroller.filteredRecords[index]["title"]
                                .toString(),
                            city: datacontroller.filteredRecords[index]["city"]
                                .toString(),
                            rating: datacontroller.filteredRecords[index]
                                    ["averageRating"] ??
                                0.0,
                            imagelink: datacontroller.filteredRecords[index]
                                    ["imageurl"]
                                .toString()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        label: 'Attractions',
        onTap: (index) {
          if (index == 1) {
            Get.to(() => ProfileSettingsPage(fromPage: 'HomePage'));
          }
        },
      ),
    );
  }

  Widget _categoryButton(String category) {
    return Obx(
      () => myButton(
        Function: () {
          _selectedCategory.value = category; // Update the selected category
          datacontroller.fetchData(
              city: ciity,
              category: category); // Fetch data based on the selected category
        },
        buttontext: category,
        isActive: _selectedCategory.value ==
            category, // Check if this button is for the selected category
      ),
    );
  }
}
