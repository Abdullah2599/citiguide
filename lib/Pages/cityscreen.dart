import 'package:cached_network_image/cached_network_image.dart';
import 'package:citiguide/Pages/homepage.dart';
import 'package:citiguide/Pages/profile_page.dart';
import 'package:citiguide/Pages/tourist_details.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/bottomnavigationbar.dart';
import 'package:citiguide/components/reusable/citycard.dart';
import 'package:citiguide/controllers/CityController.dart';
import 'package:citiguide/models/citymodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityScreen extends StatelessWidget {
  CityScreen({super.key});

  CityController cityController = CityController();

  @override
  Widget build(BuildContext context) {
    cityController.fetchCities();
    return Scaffold(
      appBar: app_Bar('Cities', false),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color.fromARGB(255, 5, 6, 58),
                Color.fromARGB(255, 5, 6, 39),
              ]),
        ),
        child: Column(
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
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 30.0,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  // Sort the cities alphabetically
                  List sortedCities = List.from(cityController.citiesRecords)
                    ..sort(
                        (a, b) => (a["cname"] as String).compareTo(b["cname"]));

                  return GridView.builder(
                    itemCount: sortedCities.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onLongPress: () {
                            bottomSheet(context, sortedCities[index]);
                          },
                          onTap: () => Get.to(() => HomePage(
                                ciity: sortedCities[index]["cname"],
                              )),
                          child: CityCard(
                            cityimg: sortedCities[index]["cimg"].toString(),
                            cityname: sortedCities[index]["cname"].toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        label: 'Cities',
        onTap: (index) {
          if (index == 1) {
            Get.to(() => ProfileSettingsPage(fromPage: 'CityScreen'));
          }
        },
      ),
    );
  }
}

Future<void> bottomSheet(BuildContext context, Map<dynamic, dynamic> cityData) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                  )
                ],
              ),
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: cityData["cimg"], // Use cityData for image URL
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              cityData["cname"], // Use cityData for city name
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 8),
            Text(
              cityData["cdesc"] ??
                  'No description available', // Use cityData for city description
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ),
  );
}
