import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class Likedatacontroller extends GetxController {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  RxList<dynamic> likedPlaces = RxList<dynamic>([]);
  // final String city;

  @override
  void onInit() {
    super.onInit();

    Likedatacontroller();
    fetchLikedPlaces();
  }

  void fetchLikedPlaces() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      print("User is not logged in.");
      return;
    }

    final userRef = databaseRef.child('users/${user.uid}/likedPlaces');
    userRef.onValue.listen((event) async {
      final likedPlacesSnapshot = event.snapshot;
      if (likedPlacesSnapshot.exists) {
        final likedPlacesMap =
            Map<String, dynamic>.from(likedPlacesSnapshot.value as Map);
        final placesRef = databaseRef.child('data');
        List<dynamic> placesList = [];

        for (var placeId in likedPlacesMap.keys) {
          final placeSnapshot = await placesRef.child(placeId).get();
          if (placeSnapshot.exists) {
            final placeData =
                Map<String, dynamic>.from(placeSnapshot.value as Map);
            placesList.add(placeData);
          }
        }
        likedPlaces.value = placesList;
      } else {
        likedPlaces.value = [];
      }
    });
  }
}
