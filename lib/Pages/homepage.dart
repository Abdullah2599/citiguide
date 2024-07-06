import 'package:citiguide/Pages/tourist_details.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/places_tile.dart';
import 'package:citiguide/components/reusable/textbutton.dart';
import 'package:citiguide/controllers/DataController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, this.ciity});

  final  ciity;
  Datacontroller datacontroller = new Datacontroller();

  @override
  Widget build(BuildContext context) {
    datacontroller.fetchData(city: ciity);
    print("lenght " + datacontroller.Records.length.toString());
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 244, 248),
      appBar: app_Bar("city Name"),
      body: Column(
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
            child: Obx( 
              () => ListView.builder(
                itemCount: datacontroller.Records.length,
                physics: NeverScrollableScrollPhysics(),
                   itemBuilder: (context, index) {
                return  GestureDetector(
                  child: PlacesTile(
                        name: datacontroller.Records[index]["title"].toString(),
                        city: "Paris",
                        rating: 4.9,
                        price: 300,
                        imagelink:
                            "https://images.pexels.com/photos/532826/pexels-photo-532826.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                );
                },
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
