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
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityScreen extends StatelessWidget {
  List cityList = [];

  CityScreen({super.key});

  CityController cityController = new CityController();

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
                    // borderSide: BorderSide(width: 0.8),
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
                () => GridView.builder(
                  itemCount: cityController.citiesRecords.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onLongPress: () {
                            bottomSheet(context);
                          },
                          onTap: () => Get.to(() => HomePage(
                                ciity: cityController.citiesRecords[index]
                                    ["cname"],
                              )),
                          child: CityCard(
                            cityimg: cityController.citiesRecords[index]["cimg"]
                                .toString(),
                            cityname: cityController.citiesRecords[index]
                                    ["cname"]
                                .toString(),
                          ),
                        ));
                  },
                ),
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

Future bottomSheet(BuildContext context) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (context) => SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 18,
                            blurStyle: BlurStyle.outer)
                      ]),
                      height: 200,
                      width: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://images.pexels.com/photos/208745/pexels-photo-208745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                          height: 500,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          Text(
                            "Desc",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
}
