import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  var likedPlaces = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var like = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLikedPlaces();
  }

  @override
  void onClose() {
    // Close any streams or listeners here
    super.onClose();
  }

  Future<void> fetchLikedPlaces() async {
    try {
      isLoading.value = true;
      HapticFeedback.lightImpact();
      likedPlaces.clear();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user is logged in.');
        return;
      }
      String email = user.email!;

      DatabaseReference ref = FirebaseDatabase.instance.ref('data');

      DatabaseEvent event = await ref.once();

      for (var element in event.snapshot.children) {
        Map<dynamic, dynamic> data = element.value as Map<dynamic, dynamic>;
        String id = element.key!;

        var likes = data['likes'] as List<dynamic>? ?? [];
        if (likes.contains(email)) {
          final placeData = Map<String, dynamic>.from(data);
          placeData['id'] = id;

          double averageRating = await fetchAverageRating(id);
          placeData['averageRating'] = averageRating;

          likedPlaces.add(placeData);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<double> fetchAverageRating(String placeId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("reviews");
    DatabaseEvent event =
        await ref.orderByChild('dataid').equalTo(placeId).once();

    if (event.snapshot.value == null) {
      return 0.0;
    }

    Map<dynamic, dynamic> reviews =
        event.snapshot.value as Map<dynamic, dynamic>;
    double totalRating = 0.0;
    int count = 0;

    reviews.forEach((key, value) {
      totalRating += (value['rating'] as num).toDouble();
      count++;
    });

    return count > 0 ? totalRating / count : 0.0;
  }

  Future<void> likeOrUnlike(String placeId, bool isLiked) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      return;
    }

    String email = user.email!;
    DatabaseReference placeRef =
        FirebaseDatabase.instance.ref('data/$placeId/likes');

    // Fetch the current likes
    DataSnapshot snapshot = await placeRef.get();

    List<String> likes = [];
    if (snapshot.exists && snapshot.value is List) {
      likes = List<String>.from(snapshot.value as List);
    } else if (snapshot.exists && snapshot.value is Map) {
      likes = List<String>.from((snapshot.value as Map).values);
    }

    if (isLiked) {
      // Add email to the likes if not already present
      if (!likes.contains(email)) {
        likes.add(email);
        HapticFeedback.lightImpact();
        Get.snackbar(
          "Message",
          "You liked this place",
          backgroundColor: Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
      }
    } else {
      // Remove email from the likes if present
      if (likes.contains(email)) {
        likes.remove(email);
        HapticFeedback.lightImpact();
        Get.snackbar(
          "Message",
          "You unliked this place",
          backgroundColor: Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
      }
    }

    // Update the likes array in Realtime Database
    await placeRef.set(likes);

    // Update the like state
    like.value = isLiked;

    // Refresh the liked places list
    fetchLikedPlaces();
  }

  void checkLikeStatus(String placeId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) return;

    String email = user.email!;
    DatabaseReference placeRef =
        FirebaseDatabase.instance.ref('data/$placeId/likes');

    DataSnapshot snapshot = await placeRef.get();
    if (snapshot.exists) {
      var likes = snapshot.value as List<dynamic>;
      like.value = likes.contains(email);
    } else {
      like.value = false;
    }
  }
}
