import 'package:CityNavigator/Pages/eventsdetails.dart';
import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/components/reusable/eventstile.dart';
import 'package:CityNavigator/controllers/EventsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsScreen extends StatelessWidget {
  final String city;
  EventsScreen({required this.city});

  @override
  Widget build(BuildContext context) {

    final EventsController eventsController =
        Get.put(EventsController(city: city));
    print(eventsController.eventsList.length);
    print(eventsController.eventsList);
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
          'Events in $city',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (eventsController.isLoading.value) {
          return const Center(
            child: GFLoader(
              loaderColorOne: Color.fromARGB(255, 0, 250, 217),
              loaderColorTwo: Color.fromARGB(255, 123, 255, 237),
              loaderColorThree: Color.fromARGB(255, 201, 255, 248),
              size: GFSize.LARGE,
              type: GFLoaderType.square,
            ),
          );
        } else if (eventsController.eventsList.isEmpty) {
          return Center(
            child: Text(
              'No events found for $city',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
       return ListView.builder(
            itemCount: eventsController.eventsList.length,
            itemBuilder: (context, index) {
              var eventEntry = eventsController.eventsList[index];

              var eventId = eventEntry['id']; // Access the parent document ID
              var eventData = eventEntry['data']; // Access the actual event data

              return GestureDetector(
                onTap: () {
                  Get.to(() => Eventsdetails(
                        eventData: eventData, // Pass the event data
                        eventId: eventId,     // Pass the parent document ID
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customEvents(
                    imageurl: eventData['imageurl'] ?? '', // Use null-aware operator
                    title: eventData['title'] ?? 'Untitled', // Provide a default
                    description: eventData['description'] ?? 'No description available', // Provide a default
                    onDTap: () {
                      launchUrl(Uri.parse(eventData["contact"]?.toString() ?? ''),
                          mode: LaunchMode.inAppBrowserView);
                    },
                  ),
                ),
              );});
        }
      }),
    );
  }
}
