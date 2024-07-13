import 'package:citiguide/Pages/Favorites/likeddetails.dart';
import 'package:citiguide/Pages/profile_page.dart';
import 'package:citiguide/components/reusable/appbar.dart';
import 'package:citiguide/components/reusable/bottomnavigationbar.dart';
import 'package:citiguide/components/reusable/places_tile.dart';
import 'package:citiguide/Pages/Favorites/FavoritesController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.put(FavoritesController());

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
                await Get.to(() => LikedDetails(
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
