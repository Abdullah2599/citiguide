import 'package:cached_network_image/cached_network_image.dart';
import 'package:CityNavigator/Theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Eventsdetails extends StatelessWidget {
  final Map<dynamic, dynamic> eventData;

  Eventsdetails({required this.eventData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        clipBehavior: Clip.hardEdge,
        foregroundColor: Colors.white,
        backgroundColor: ColorTheme.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          eventData['title'] ?? 'Event', // Display event title
          style: TextStyle(color: Colors.white),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.share),
        //     onPressed: () {
        //       // Share event details
        //     },
        //   )
        // ],
      ),
      body: Stack(children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: CachedNetworkImage(
                  imageUrl: eventData['imageurl'] ?? '', // Display event image
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  eventData['title'] ?? '', // Display event title
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, size: 25, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      eventData['date'] ?? '', // Display event date
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Spacer(),
                    Icon(Icons.timer, size: 25, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      eventData['time'] ?? '', // Display event time
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  eventData['description'] ?? '', // Display event description
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
                color: ColorTheme.primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$35.00', // You can customize this to show event price or other relevant info
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // Handle booking logic
                      },
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ))
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
