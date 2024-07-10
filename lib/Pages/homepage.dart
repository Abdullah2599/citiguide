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
  Datacontroller datacontroller = Get.put(Datacontroller());
  final RxString _selectedCategory = 'Popular Attractions'.obs;
  final List<String> categories = [
    "Popular Attractions",
    "Hotels",
    "Restaurants",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {
    datacontroller.fetchData(city: ciity, category: _selectedCategory.value);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 244, 248),
      appBar: app_Bar(ciity, true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                hintText: 'Search Cities and Places',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 30.0,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.clear),
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
              // mainAxisSize: MainAxisSize.min,
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
              () => ListView.builder(
                itemCount: datacontroller.Records.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Get.to(() => TilesDetails(
                              placeData: datacontroller.Records[index],
                              placeId: datacontroller.Records[index]['id'],
                            ))!
                        .then((value) {
                      datacontroller.fetchData(
                        city: ciity,
                        category: _selectedCategory.value,
                      );
                    }),
                    child: PlacesTile(
                        name: datacontroller.Records[index]["title"].toString(),
                        city: datacontroller.Records[index]["city"].toString(),
                        rating: datacontroller.Records[index]
                                ["averageRating"] ??
                            0.0,
                        imagelink: datacontroller.Records[index]["imageurl"]
                            .toString()),
                  );
                },
              ),
            ),
          ),
        ],
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
