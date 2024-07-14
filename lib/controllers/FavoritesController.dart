import 'package:citiguide/Golobal%20Loader/boxrotation.dart';
import 'package:citiguide/Golobal%20Loader/boxrotationmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  var likedPlaces = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs; // Track loading state

// FavoritesController({}) {
//     this.likedPlaces;
//   }
  @override
  void onInit() {
    super.onInit();
    fetchLikedPlaces();
    //  FavoritesController();
  }

  Future<void> fetchLikedPlaces() async {
    try {
      isLoading.value = true; // Start loading
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
    } catch (e) {
      print('Error fetching liked places: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<double> fetchAverageRating(String placeId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('data/$placeId/averageRating');
    DatabaseEvent event = await ref.once();
    return event.snapshot.value as double? ?? 0.0;
  }
}
