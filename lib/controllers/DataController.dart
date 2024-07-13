import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class Datacontroller extends GetxController {
  RxList<dynamic> Records = <dynamic>[].obs;
  RxList<dynamic> filteredRecords = <dynamic>[].obs;
  final RxString currentQuery = ''.obs;
  final String city;
  RxString? category;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxBool isSearching = false.obs;

  Datacontroller({required this.city, String? category}) {
    this.category = (category ?? 'All').obs;
  }

  @override
  void onInit() {
    super.onInit();
    fetchData(city: city, category: category!.value);
    searchController.addListener(() {
      searchRecords(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchData(
      {required String city, required String category}) async {

    DatabaseReference ref = FirebaseDatabase.instance.ref("data");

    // Get the data once
    DatabaseEvent event = await ref.once();

    // Clear the list before populating it
    Records.clear();

    // Iterate through children and add values to the list
    for (var element in event.snapshot.children) {
      Map<dynamic, dynamic> data = element.value as Map<dynamic, dynamic>;
      String id = element.key!;

      if (data['city'].toString() == city) {
        if (category.toLowerCase() == 'all' ||
            data['category'].toString().toLowerCase() ==
                category.toLowerCase()) {
          data['id'] = id;

          // fetching average rating
          double averageRating = await fetchAverageRating(id);
          data['averageRating'] = averageRating;

          Records.add(data);
        }
      }
    }
    filteredRecords.value = Records;
    if (currentQuery.isNotEmpty) {
      searchRecords(currentQuery.value);
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
    filteredRecords.sort((a, b) {
      double ratingA = a['averageRating'] ?? 0.0;
      double ratingB = b['averageRating'] ?? 0.0;

      if (ascending) {
        return ratingA.compareTo(ratingB);
      } else {
        return ratingB.compareTo(ratingA);
      }
    });
  }

  void searchRecords(String query) {
    currentQuery.value = query;
    if (query.isEmpty) {
      filteredRecords.value = Records;
      isSearching.value = false;
    } else {
      filteredRecords.value = Records.where((record) => record['title']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())).toList();
      isSearching.value = true;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchRecords('');
    searchFocusNode.unfocus();
  }
}
