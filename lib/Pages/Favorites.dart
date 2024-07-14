import 'package:citiguide/Pages/Favorites/likeddetails.dart';
import 'package:citiguide/Pages/maindetails.dart';
import 'package:citiguide/Pages/profile_page.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/bottomnavigationbar.dart';
import 'package:citiguide/components/reusable/places_tile.dart';
import 'package:citiguide/controllers/FavoritesController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesController favoritesController =
      Get.put(FavoritesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_Bar('Favorites', true),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        label: 'Cities',
        showLikeButton: true,
        onTap: (index) {
          if (index == 2) {
            Get.to(() => ProfileSettingsPage(fromPage: 'CityScreen'));
          } else if (index == 0) {
            Get.back();
          }
        },
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: favoritesController.likedPlaces.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final place = favoritesController.likedPlaces[index];
            return GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                await Get.to(() => TilesDetails(
                      placeData: place,
                      placeId: place['id'],
                    ));
                favoritesController
                    .fetchLikedPlaces(); // Update list after returning
              },
              child: PlacesTile(
                name: place["title"].toString(),
                city: place["city"].toString(),
                rating: place["averageRating"] ?? 0.0,
                imagelink: place["imageurl"].toString(),
              ),
            );
          },
        ),
      ),
    );
  }
}
