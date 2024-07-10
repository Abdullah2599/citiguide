import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class Datacontroller extends GetxController {
  late RxList<dynamic> Records = [].obs;

  @override
  void onInit() {
    super.onInit();
    // fetchData();
  }

  Future<void> fetchData({required String city, String? category}) async {
    Records.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref("data");

    // Get the data once
    DatabaseEvent event = await ref.once();

    // Clear the list before populating it
    Records.clear();

    // Iterate through children and add values to the list
    for (var element in event.snapshot.children) {
      Map<dynamic, dynamic> data = element.value as Map<dynamic, dynamic>;
      String id = element.key!; // Get the unique ID

      if (data['city'].toString() == city) {
        if (category == null ||
            data['category'].toString().toLowerCase() ==
                category.toLowerCase()) {
          // Add the ID to the data map
          data['id'] = id;

          // Fetch average rating
          double averageRating = await fetchAverageRating(id);
          data['averageRating'] = averageRating;

          Records.add(data);
        }
      }
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

  void sortByRating({bool ascending = true}) {
    Records.sort((a, b) {
      if (ascending) {
        return (a['averageRating'] as double)
            .compareTo(b['averageRating'] as double);
      } else {
        return (b['averageRating'] as double)
            .compareTo(a['averageRating'] as double);
      }
    });
  }
}
