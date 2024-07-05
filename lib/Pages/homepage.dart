import 'package:citiguide/Pages/tourist_details.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/places_tile.dart';
import 'package:citiguide/components/reusable/textbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 244, 248),
      appBar: app_Bar("city Name"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  // borderSide: BorderSide(width: 0.8),
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
              children: [
                myButon(Function: () {}, buttontext: "Hotels"),
                myButon(Function: () {}, buttontext: "Restaurants"),
                myButon(Function: () {}, buttontext: "Popoular attractions"),
                myButon(Function: () {}, buttontext: "Others")
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => Get.to(const TouristDetailsPage(
                  image:
                      "https://images.pexels.com/photos/2845013/pexels-photo-2845013.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")),
              child: ListView(
                children: const [
                  PlacesTile(
                    name: "Eiffel Tower",
                    city: "Paris",
                    rating: 4.9,
                    price: 300,
                    imagelink:
                        "https://images.pexels.com/photos/532826/pexels-photo-532826.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                  ),
                  PlacesTile(
                    name: "Sydney Opera House",
                    city: "Sydney",
                    rating: 4.8,
                    price: 500,
                    imagelink:
                        "https://images.pexels.com/photos/2845013/pexels-photo-2845013.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                  ),
                  PlacesTile(
                    name: "Statue of Liberty",
                    city: "New York",
                    rating: 4.7,
                    price: 400,
                    imagelink:
                        "https://images.pexels.com/photos/290386/pexels-photo-290386.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                  ),
                  PlacesTile(
                    name: "Taj Mahal",
                    city: "Agra",
                    rating: 4.9,
                    price: 250,
                    imagelink:
                        "https://images.pexels.com/photos/1583339/pexels-photo-1583339.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 30,
          selectedItemColor: ColorTheme.primaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: 'Places',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
    );
  }
}
